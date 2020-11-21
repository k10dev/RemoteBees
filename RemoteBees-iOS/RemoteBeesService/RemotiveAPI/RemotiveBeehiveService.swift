//
//  RemotiveBeehiveService.swift
//  RemoteBees
//

import HTTPServiceKit
import PromiseKit

class RemotiveBeehiveService: HTTPService, BeehiveService {

    func getJobs() -> Promise<[Job]> {
        let cache = CacheCriteria(policy: .useAge, age: CacheAge.oneDay.interval)
        let p: Promise<Jobs> = self.get(route: "/remote-jobs", cacheCriteria: cache)
        return p.map { $0.jobs }
    }

}
