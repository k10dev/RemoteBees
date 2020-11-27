//
//  RemoteBeesServiceManager.swift
//  RemoteBees
//

import Foundation

public class RemoteBeesServiceManager: ServiceManager {

    private let couchbaseDb: CouchbaseLite?

    private let configuration: RemoteBeesServiceConfiguration

    public init(configuration: RemoteBeesServiceConfiguration) {
        self.configuration = configuration
        self.couchbaseDb = try? CouchbaseLite(name: "RemoteBees", localeIdentifier: configuration.localeIdentifier)
    }

    deinit {
        do {
            try self.couchbaseDb?.close()            
        } catch {}
    }

    public var beehiveService: BeehiveService {
        return RemotiveBeehiveService(config: self.configuration.remotive(), couchbaseDb: self.couchbaseDb)
    }

}
