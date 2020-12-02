package dev.beehive.remotebees.flow

import android.net.Uri
import android.os.Parcelable
import androidx.browser.customtabs.CustomTabsIntent
import com.inmotionsoftware.flowkit.android.StateMachineActivity
import com.inmotionsoftware.flowkit.back
import com.inmotionsoftware.flowkit.cancel
import com.inmotionsoftware.httpservice.concurrent.DispatchExecutor
import com.inmotionsoftware.promisekt.Promise
import com.inmotionsoftware.promisekt.features.after
import com.inmotionsoftware.promisekt.map
import com.inmotionsoftware.promisekt.then
import dev.beehive.remotebees.app.AppProxy
import dev.beehive.remotebees.fragment.JobBoardFragment
import dev.beehive.remotebees.service.api.JobSearchType
import dev.beehive.remotebees.service.domain.Job
import kotlinx.android.parcel.Parcelize

private fun Job.toJobItem(): JobItem {
    return JobItem(id = this.id,
                    url = this.url,
                    title = this.title,
                    companyName = this.companyName,
                    category = this.category,
                    publicationDate = this.publicationDate,
                    salary = this.salary
                )
}

@Parcelize
class AllJobs: AsyncJobItems, Parcelable {
    private var jobItems: List<JobItem> = emptyList()

    override fun jobItems(): Promise<List<JobItem>> {
        return if (this.jobItems.isNotEmpty()) {
            Promise.value(this.jobItems)
        } else {
            AppProxy.proxy.serviceManager.beehiveService.getAllJobs()
                .map { jobs ->
                    val jobItems = jobs.map { it.toJobItem() }
                    this.jobItems = jobItems
                    jobItems
                }
        }
    }
}

@Parcelize
class SearchJobs(private val searchTerm: String): AsyncJobItems, Parcelable {
    private var jobItems: List<JobItem> = emptyList()

    override fun jobItems(): Promise<List<JobItem>> {
        return if (this.jobItems.isNotEmpty()) {
            Promise.value(this.jobItems)
        } else {
            AppProxy.proxy.serviceManager.beehiveService.searchJobs(type = JobSearchType.Listing(this.searchTerm))
                .map { jobs ->
                    val jobItems = jobs.map { it.toJobItem() }
                    this.jobItems = jobItems
                    jobItems
                }
        }
    }
}

class JobBoardFlowController() : StateMachineActivity<JobBoardState, Unit, Unit>(), JobBoardStateMachine {

    private lateinit var jobItems: AsyncJobItems

    override fun onBegin(state: JobBoardState, context: Unit): Promise<JobBoardState.FromBegin> {
        this.jobItems = AllJobs()
        return Promise.value(JobBoardState.FromBegin.Main(this.jobItems))
    }

    override fun onMain(
        state: JobBoardState,
        context: AsyncJobItems
    ): Promise<JobBoardState.FromMain> {
        return this.subflow2(fragment = JobBoardFragment::class.java, context = context)
                    .map {
                        when (it) {
                            is JobBoardFragment.Response.Profile -> {
                                JobBoardState.FromMain.Profile(Unit)
                            }
                            is JobBoardFragment.Response.Login -> {
                                JobBoardState.FromMain.Login(Unit)
                            }
                            is JobBoardFragment.Response.Search -> {
                                JobBoardState.FromMain.Search(it.term)
                            }
                            is JobBoardFragment.Response.Select -> {
                                JobBoardState.FromMain.ViewDetail(it.job)
                            }
                        }
                    }
    }

    override fun onLogin(state: JobBoardState, context: Unit): Promise<JobBoardState.FromLogin> {
        return this.subflow(stateMachine = LoginFlowController::class.java, state = LoginState.Begin(Unit))
                    .map {
                        JobBoardState.FromLogin.Main(this.jobItems) as JobBoardState.FromLogin
                    }
                    .back {
                        JobBoardState.FromLogin.Main(this.jobItems)
                    }
                    .cancel {
                        JobBoardState.FromLogin.Main(this.jobItems)
                    }
    }

    override fun onProfile(
        state: JobBoardState,
        context: Unit
    ): Promise<JobBoardState.FromProfile> {
        TODO("Not yet implemented")
    }

    override fun onSearch(
        state: JobBoardState,
        context: String
    ): Promise<JobBoardState.FromSearch> {
        this.jobItems = if (context.isBlank()) AllJobs() else SearchJobs(searchTerm = context)
        return Promise.value(JobBoardState.FromSearch.Main(this.jobItems))
    }

    override fun onViewDetail(
        state: JobBoardState,
        context: JobItem
    ): Promise<JobBoardState.FromViewDetail> {
        val builder = CustomTabsIntent.Builder()
        val intent = builder.build()
        intent.launchUrl(this, Uri.parse(context.url))

        return Promise.value(Unit)
                .then(on = DispatchExecutor.global) { after(1.0) }
                .map {  JobBoardState.FromViewDetail.Main(this.jobItems)  }
    }

}
