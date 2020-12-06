/***************************************************************************
 * This source file is part of the RemoteBees open source project.         *
 *                                                                         *
 * Licensed under the MIT License. See LICENSE for license information     *
 ***************************************************************************/

import Foundation

public class RemoteBeesServiceManager: ServiceManager {

    private let couchbaseDb: CouchbaseLite?

    private let configuration: RemoteBeesServiceConfiguration

    public init(configuration: RemoteBeesServiceConfiguration) throws {
        self.configuration = configuration
        self.couchbaseDb = try CouchbaseLite(name: "RemoteBees", localeIdentifier: configuration.localeIdentifier)
    }

    deinit {
        do {
            try self.couchbaseDb?.close()            
        } catch {}
    }

    public var beehiveService: BeehiveService {
        return RemotiveBeehiveService(config: self.configuration.remotive(), couchbaseDb: self.couchbaseDb)
    }

    public var contentService: ContentService {
        return RemoteBeesContentService(config: self.configuration.content())
    }

}
