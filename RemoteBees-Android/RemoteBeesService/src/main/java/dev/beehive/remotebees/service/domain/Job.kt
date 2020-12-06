/***************************************************************************
 * This source file is part of the RemoteBees open source project.         *
 *                                                                         *
 * Licensed under the MIT License. See LICENSE for license information     *
 ***************************************************************************/

package dev.beehive.remotebees.service.domain

import com.squareup.moshi.Json
import java.util.*

data class Jobs(
    @Json(name="0-legal-notice")val legalNotice: String,
    @Json(name="job-count") val jobCount: Int,
    val jobs: List<Job>
)

data class Job(
    val id: Int,
    val url: String,
    val title: String,
    @Json(name ="company_name") val companyName: String,
    val category: String,
    val tags: List<String>,
    @Json(name="job_type") val jobType: String,
    @Json(name="publication_date") val publicationDate: String,
    @Json(name="candidate_required_location") val candidateRequiredLocation: String,
    val salary: String,
    val description: String,
    val documentType: String = "JOB"
)
