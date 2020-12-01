package dev.beehive.remotebees.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.RecyclerView
import com.inmotionsoftware.flowkit.android.FlowFragment
import com.inmotionsoftware.promisekt.done
import dev.beehive.remotebees.R
import dev.beehive.remotebees.app.AppProxy
import dev.beehive.remotebees.flow.AsyncJobItems
import dev.beehive.remotebees.flow.JobItem

class JobBoardFragment: FlowFragment<AsyncJobItems, JobBoardFragment.Response>() {

    sealed class Response {
        object Login: Response()
        object Profile: Response()
        data class Search(val term: String): Response()
        data class Select(val job: JobItem): Response()
    }

    private lateinit var recyclerListView: RecyclerView

    override fun onInputAttached(input: AsyncJobItems) {
        input.jobItems()
            .done {
                this.recyclerListView.adapter = JobBoardListAdapter(it)
            }
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.fragment_job_board, container, false)

        this.recyclerListView = view.findViewById<RecyclerView>(R.id.jobBoardRecyclerView).apply {
            setHasFixedSize(true)
            addItemDecoration(DividerItemDecoration(context, DividerItemDecoration.VERTICAL))
        }
        return view
    }

}

private class JobBoardListAdapter(
    private var jobs: List<JobItem>,
) : RecyclerView.Adapter<JobBoardListAdapter.JobRowViewHolder>() {

    inner class JobRowViewHolder(view: View): RecyclerView.ViewHolder(view) {
        val companyLogoImage = view.findViewById<ImageView>(R.id.companyLogoImage)
        val titleTextView = view.findViewById<TextView>(R.id.titleText)
        val companyNameTextView = view.findViewById<TextView>(R.id.companyNameText)
        val jobCategoryTextView = view.findViewById<TextView>(R.id.jobCategoryText)
    }

    override fun onCreateViewHolder(viewGroup: ViewGroup, viewType: Int): JobRowViewHolder {
        val view = LayoutInflater.from(viewGroup.context).inflate(R.layout.view_job_row, viewGroup, false)
        return JobRowViewHolder(view)
    }

    override fun getItemCount() = this.jobs.size

    override fun onBindViewHolder(holder: JobRowViewHolder, position: Int) {
        val job = this.jobs[position]
        holder.titleTextView.text = job.title
        holder.companyNameTextView.text = job.companyName
        holder.jobCategoryTextView.text = job.category

        AppProxy.proxy.serviceManager.beehiveService.getCompanyLogo(job.id)
            .done {
                if (it != null) {
                    holder.companyLogoImage.setImageBitmap(it)
                }
            }
    }

}
