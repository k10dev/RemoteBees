//
//  RemotiveBeehiveService.swift
//  RemoteBees
//

import HTTPServiceKit
import PromiseKit
import CouchbaseLiteSwift

class RemotiveBeehiveService: HTTPService, BeehiveService {

    private let couchbaseDb: CouchbaseLite?

    init(config: HTTPService.Config, couchbaseDb: CouchbaseLite?) {
        self.couchbaseDb = couchbaseDb
        super.init(config: config)
    }

    func getAllJobs() -> Promise<[Job]> {
        return Promise().then(on: DispatchQueue.global()) { _ -> Promise<[Job]> in
            if let jobs = try? self.couchbaseDb?.getJobs(), !jobs.isEmpty {
                return Promise.value(jobs)
            }
            let cache = CacheCriteria(policy: .useAge, age: CacheAge.oneDay.interval)
            let p: Promise<Jobs> = self.get(route: "/remote-jobs", cacheCriteria: cache)
            return p.map { $0.jobs }
                    .map(on: DispatchQueue.global()) {
                        try self.couchbaseDb?.saveJobs($0)
                        return $0
                    }
        }
    }

    func getJob(_ id: Int) -> Promise<Job?> {
        return Promise().map(on: DispatchQueue.global()) {
            return try self.couchbaseDb?.getJob(id)
        }
    }

    func searchJobs(by type: JobSearchType) -> Promise<[Job]> {
        let queryParams = QueryParameters()
        switch type {
            case .category(let category):
                queryParams.addQueryParameter(name: "category", value: category)
            case .companyName(let companyName):
                queryParams.addQueryParameter(name: "company_name", value: companyName)
            case .listing(let listing):
                queryParams.addQueryParameter(name: "search", value: listing)
        }
        let p: Promise<Jobs> = self.get(route: "/remote-jobs", query: queryParams)
        return p.map { $0.jobs }
    }

}

private extension CouchbaseLite {

    func saveJobs(_ jobs: [Job]) throws {
        guard self.isOpen else { return }
        let encoder = DictionaryEncoder()

        // Document expiration: 7 days
        let ttl = Calendar.current.date(byAdding: .day, value: 7, to: Date())

        try self.database.inBatch {
            try jobs.forEach { job in
                let data = try encoder.encode(job)
                let doc = MutableDocument(id: job.id.description, data: data)
                try self.database.saveDocument(doc)
                try self.database.setDocumentExpiration(withID: job.id.description, expiration: ttl)
            }
        }
    }

    func getJobs() throws -> [Job]? {
        guard self.isOpen else { return nil }
        var jobs = [Job]()

        let query = QueryBuilder
            .select(SelectResult.all())
            .from(DataSource.database(self.database))
            .where(
                Expression.property("documentType").equalTo(Expression.string("JOB"))
//                    .and(Expression.property("category").equalTo(Expression.string(category))
            )

        let decoder = DictionaryDecoder()
        for result in try query.execute() {
            let dict = result.toDictionary()["RemoteBees"] as! [String: Any]
            let job = try decoder.decode(Job.self, from: dict)
            jobs.append(job)
        }
        return jobs
    }

    func getJob(_ id: Int) throws -> Job? {
        guard self.isOpen else { return nil }
        guard let document = self.database.document(withID: id.description) else { return nil }
        let dict = document.toDictionary()
        return try DictionaryDecoder().decode(Job.self, from: dict)
    }

}
