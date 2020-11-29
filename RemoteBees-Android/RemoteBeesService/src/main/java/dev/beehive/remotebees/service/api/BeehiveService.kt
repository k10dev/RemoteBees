package dev.beehive.remotebees.service.api

import android.graphics.Bitmap
import com.inmotionsoftware.promisekt.Promise
import dev.beehive.remotebees.service.domain.Job

sealed class JobSearchType {
    data class Category(val term: String): JobSearchType()
    data class CompanyName(val term: String): JobSearchType()
    data class Listing(val term: String): JobSearchType()
}

interface BeehiveService {

    fun getAllJobs(): Promise<List<Job>>

    fun getJob(id: Int): Promise<Job?>

    fun searchJobs(type: JobSearchType): Promise<List<Job>>

    fun getCompanyLogo(id: Int): Promise<Bitmap?>

}
