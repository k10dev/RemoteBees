package dev.beehive.remotebees.service.internal

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import com.couchbase.lite.*
import com.inmotionsoftware.httpservice.HTTPService
import com.inmotionsoftware.httpservice.QueryParameters
import com.inmotionsoftware.httpservice.cache.CacheAge
import com.inmotionsoftware.httpservice.cache.CacheCriteria
import com.inmotionsoftware.httpservice.cache.CachePolicy
import com.inmotionsoftware.httpservice.concurrent.DispatchExecutor
import com.inmotionsoftware.httpservice.get
import com.inmotionsoftware.promisekt.Promise
import com.inmotionsoftware.promisekt.map
import com.inmotionsoftware.promisekt.thenMap
import com.squareup.moshi.JsonDataException
import dev.beehive.remotebees.service.api.BeehiveService
import dev.beehive.remotebees.service.api.JobSearchType
import dev.beehive.remotebees.service.domain.Job
import dev.beehive.remotebees.service.domain.Jobs
import dev.beehive.remotebees.service.internal.couchbase.CouchbaseLiteDb
import dev.beehive.remotebees.service.internal.couchbase.DictionaryDecoder
import dev.beehive.remotebees.service.internal.couchbase.DictionaryEncoder
import java.util.*
import kotlin.jvm.Throws

internal class RemotiveBeehiveService(
    config: HTTPService.Config,
    private val couchbaseDb: CouchbaseLiteDb?
): HTTPService(config), BeehiveService {

    override fun getAllJobs(): Promise<List<Job>> {
        return Promise.value(Unit).thenMap(on=DispatchExecutor.global) {
            val jobs = this.couchbaseDb?.getJobs()
            if (!jobs.isNullOrEmpty()) {
                Promise.value(jobs)
            } else {
                val cache = CacheCriteria(policy= CachePolicy.useAge, age= CacheAge.oneDay.interval)
                this.get(route="api/remote-jobs", type=Jobs::class.java, cacheCriteria=cache)
                    .map(on=DispatchExecutor.global) {
                        it.jobs.also { this.couchbaseDb?.saveJobs(it) }
                    }
            }
        }
    }

    override fun getJob(id: Int): Promise<Job?> {
        return Promise.value(Unit).map(on=DispatchExecutor.global) {
            this.couchbaseDb?.getJob(id)
        }
    }

    override fun searchJobs(type: JobSearchType): Promise<List<Job>> {
        val queryParams = QueryParameters()
        when (type) {
            is JobSearchType.Category -> {
               queryParams.addQueryParameter(name="category", value=type.term)
            }
            is JobSearchType.CompanyName -> {
                queryParams.addQueryParameter(name="company_name", value=type.term)
            }
            is JobSearchType.Listing -> {
                queryParams.addQueryParameter(name="search", value=type.term)
            }
        }
        return this.get(route="api/remote-jobs", type=Jobs::class.java, query=queryParams)
                   .map { it.jobs }
    }

    override fun getCompanyLogo(id: Int): Promise<Bitmap?> {
        val criteria = CacheCriteria(policy=CachePolicy.useAge, age=CacheAge.immortal.interval)
        return this.get(route="web/image/hr.job/${id}/logo", cacheCriteria=criteria)
                    .map(on=DispatchExecutor.global) {
                        val data = it?.body ?: return@map  null
                        BitmapFactory.decodeByteArray(data, 0, data.size)
                    }
    }

}

///
/// CouchbaseLiteDb Extension
///

@Throws
private fun CouchbaseLiteDb.saveJobs(jobs: List<Job>) {
    val encoder = DictionaryEncoder()

    // Document expiration: 7 days
    val calendar = Calendar.getInstance()
    calendar.add(Calendar.DAY_OF_YEAR, 7)
    val ttl = calendar.time

    this.database.inBatch {
        jobs.forEach { job ->
            val data = encoder.encode(job)
            val doc = MutableDocument(job.id.toString(), data)
            this.database.save(doc)
            this.database.setDocumentExpiration(job.id.toString(), ttl)
        }
    }
}

@Throws
private fun CouchbaseLiteDb.getJobs(): List<Job> {
    val jobs = mutableListOf<Job>()

    val query = QueryBuilder
            .select(SelectResult.all())
            .from(DataSource.database(this.database))
            .where(
                Expression.property("documentType").equalTo(Expression.string("JOB"))
//                    .and(Expression.property("category").equalTo(Expression.string(category))
            )

    val decoder = DictionaryDecoder()
    for (result in query.execute()) {
        val dict = result.toMap()["RemoteBees"] as Map<String, Any>
        try {
            val job = decoder.decode(Job::class.java, value = dict) ?: continue
            jobs.add(job)
        } catch (e: JsonDataException) {
            // return empty list so it re-caches model info
            return emptyList()
        }
    }
    return jobs
}

@Throws
private fun CouchbaseLiteDb.getJob(id: Int): Job? {
    val document = this.database.getDocument(id.toString()) ?: return null
    val dict = document.toMap()
    return DictionaryDecoder().decode(Job::class.java, value=dict)
}
