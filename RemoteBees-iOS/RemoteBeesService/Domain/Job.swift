/***************************************************************************
 * This source file is part of the RemoteBees open source project.         *
 *                                                                         *
 * Licensed under the MIT License. See LICENSE for license information     *
 ***************************************************************************/

import Foundation

public struct Jobs: Codable {
    public let legalNotice: String
    public let jobCount: Int
    public let jobs: [Job]
    
    private enum CodingKeys: String, CodingKey {
        case legalNotice = "0-legal-notice"
        case jobCount = "job-count"
        case jobs
    }
}

public struct Job: Hashable, Codable, Identifiable {
    public let id: Int
    public let url: String
    public let title: String
    public let companyName: String
    public let category: String
    public let tags: [String]
    public let jobType: String
    public let publicationDate: Date
    public let candidateRequiredLocation: String
    public let salary: String
    public let description: String
    public let documentType: String = "JOB"

    private enum CodingKeys: String, CodingKey {
        case id
        case url
        case title
        case companyName = "company_name"
        case category
        case tags
        case jobType = "job_type"
        case publicationDate = "publication_date"
        case candidateRequiredLocation = "candidate_required_location"
        case salary
        case description
        case documentType
    }
}
