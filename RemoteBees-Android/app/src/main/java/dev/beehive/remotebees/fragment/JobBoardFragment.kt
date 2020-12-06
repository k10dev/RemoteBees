/***************************************************************************
 * This source file is part of the RemoteBees open source project.         *
 *                                                                         *
 * Licensed under the MIT License. See LICENSE for license information     *
 ***************************************************************************/

package dev.beehive.remotebees.fragment

import android.content.Context
import android.net.Uri
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.inputmethod.InputMethodManager
import android.widget.Button
import android.widget.EditText
import android.widget.ImageView
import android.widget.TextView
import androidx.browser.customtabs.CustomTabsIntent
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.RecyclerView
import com.airbnb.lottie.LottieAnimationView
import com.inmotionsoftware.flowkit.android.FlowFragment
import com.inmotionsoftware.logging.Logger
import com.inmotionsoftware.logging.error
import com.inmotionsoftware.promisekt.catch
import com.inmotionsoftware.promisekt.done
import com.inmotionsoftware.promisekt.ensure
import dev.beehive.remotebees.R
import dev.beehive.remotebees.app.AppProxy
import dev.beehive.remotebees.flow.AsyncJobItems
import dev.beehive.remotebees.flow.JobItem


class JobBoardFragment
    : FlowFragment<AsyncJobItems, JobBoardFragment.Response>(), JobBoardListAdapter.OnClickListener {

    sealed class Response {
        object Login: Response()
        object Profile: Response()
        data class Search(val term: String): Response()
        data class Select(val job: JobItem): Response()
    }

    private lateinit var recyclerListView: RecyclerView
    private lateinit var searchEdit: EditText

    private var loadingView: LottieAnimationView? = null
    private val logger = Logger("dev.beehive.remotebees.JobBoardFragment")

    override fun onInputAttached(input: AsyncJobItems) {
        this.loadingView?.visibility = View.VISIBLE
        input.jobItems()
            .done {
                this.recyclerListView.adapter = JobBoardListAdapter(it, this)
            }
            .ensure {
                this.loadingView?.visibility = View.INVISIBLE
            }
            .catch {
                //TODO: Handle error
                this.logger.error(it)
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
        this.searchEdit = view.findViewById(R.id.searchEdit)
        view.findViewById<Button>(R.id.searchBtn).setOnClickListener {
            this.onSearch()
        }

        this.loadingView = view.findViewById(R.id.loadingView)
        this.loadingView?.visibility = View.VISIBLE

        return view
    }

    override fun onClick(job: JobItem) {
        val builder = CustomTabsIntent.Builder()
        builder.setToolbarColor(ContextCompat.getColor(this.requireContext(), R.color.beehiveBrand))

        val intent = builder.build()
        intent.launchUrl(this.requireContext(), Uri.parse(job.url))

//        this.resolve(Response.Select(job))
    }

    private fun onSearch() {
        // Hide the keyboard on search
        val imm = this.requireActivity().getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
        imm.hideSoftInputFromWindow(this.searchEdit.windowToken, 0)

        val term = this.searchEdit.text.toString()
        this.resolve(Response.Search(term))
    }
}

private class JobBoardListAdapter(
        private var jobs: List<JobItem>,
        private val clickListener: OnClickListener? = null
) : RecyclerView.Adapter<JobBoardListAdapter.JobRowViewHolder>() {

    interface OnClickListener {
        fun onClick(job: JobItem)
    }

    inner class JobRowViewHolder(private val view: View, private val clickListener: OnClickListener? = null): RecyclerView.ViewHolder(view) {
        private val companyLogoImage = view.findViewById<ImageView>(R.id.companyLogoImage)
        private val titleTextView = view.findViewById<TextView>(R.id.titleText)
        private val companyNameTextView = view.findViewById<TextView>(R.id.companyNameText)
        private val jobCategoryTextView = view.findViewById<TextView>(R.id.jobCategoryText)

        fun bind(job: JobItem) {
            this.titleTextView.text = job.title
            this.companyNameTextView.text = job.companyName
            this.jobCategoryTextView.text = job.category

            this.view.setOnClickListener {
                this.clickListener?.onClick(job)
            }

            AppProxy.proxy.serviceManager.beehiveService.getCompanyLogo(job.id)
                    .done { it?.let(this.companyLogoImage::setImageBitmap) }
        }
    }

    override fun onCreateViewHolder(viewGroup: ViewGroup, viewType: Int): JobRowViewHolder {
        val view = LayoutInflater.from(viewGroup.context).inflate(R.layout.view_job_row, viewGroup, false)
        return JobRowViewHolder(view, this.clickListener)
    }

    override fun getItemCount() = this.jobs.size

    override fun onBindViewHolder(holder: JobRowViewHolder, position: Int) {
        holder.bind(this.jobs[position])
    }

}
