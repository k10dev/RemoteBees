//
//  BeehiveService.swift
//  RemoteBees
//

import PromiseKit

public protocol BeehiveService {
    
    func getJobs() -> Promise<[Job]>

}
