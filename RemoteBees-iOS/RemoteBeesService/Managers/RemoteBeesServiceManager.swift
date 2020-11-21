//
//  RemoteBeesServiceManager.swift
//  RemoteBees
//

import Foundation

public class RemoteBeesServiceManager: ServiceManager {
    private let configuration: RemoteBeesServiceConfiguration

    public init(configuration: RemoteBeesServiceConfiguration) {
        self.configuration = configuration
    }

    public var beehiveService: BeehiveService {
        return RemotiveBeehiveService(config: self.configuration.remotive())
    }
}
