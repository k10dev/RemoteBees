//
//  BeehiveService.swift
//  RemoteBees
//

import PromiseKit

public enum JobSearchType {
    case category(String)
    case companyName(String)
    case listing(String)
}

public protocol BeehiveService {
    
    func getAllJobs() -> Promise<[Job]>

    func getJob(_ id: Int) -> Promise<Job?>

    func searchJobs(by type: JobSearchType) -> Promise<[Job]>

}
