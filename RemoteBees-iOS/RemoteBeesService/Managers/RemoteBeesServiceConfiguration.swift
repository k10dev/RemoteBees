//
//  RemoteBeesServiceConfiguration.swift
//  RemoteBees
//

import Foundation
import HTTPServiceKit

public enum RemoteBeesServiceEnvironment: String {
    case development
    case staging
    case production
    
    var remotiveUrl: URL {
        switch self {
            case .development, .staging, .production:
                return URL(string: "https://remotive.io/")!
        }
    }
}

public struct RemoteBeesServiceConfiguration {
    public let environment: RemoteBeesServiceEnvironment
    public let localeIdentifier: String
    public let requestTimeoutInterval: TimeInterval
    public let logger: HTTPServiceLogger?
    
    public init(
        environment: RemoteBeesServiceEnvironment,
        localeIdentifier: String,
        requestTimeoutInterval: TimeInterval = 30.0,
        logger: HTTPServiceLogger? = HTTPServiceConsoleLogger()
    ) {
        self.environment = environment
        self.localeIdentifier = localeIdentifier
        self.requestTimeoutInterval = requestTimeoutInterval
        self.logger = logger
    }
}

extension RemoteBeesServiceConfiguration {
    private static let decoders: [String: HTTPServiceDecoder] = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"  // Remotive date format
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(formatter)

        return [
            "application/xml": jsonDecoder,
            "application/json": jsonDecoder,
        ]
    }()

    func content() -> HTTPService.Config {
        var httpServiceConfig = HTTPService.Config(baseUrl: nil)
        httpServiceConfig.requestTimeoutInterval = self.requestTimeoutInterval
        httpServiceConfig.headers.merge(["Cache-Control": "no-cache"]) { (_, new) in new }
        httpServiceConfig.cacheStore = URLCache.shared
        return httpServiceConfig
    }

    func remotive() -> HTTPService.Config {
        var httpServiceConfig = HTTPService.Config(baseUrl: self.environment.remotiveUrl)
        
        // Configure headers as needed. For example
        var headers = [String: String]()

        /*
        if !self.environment.appToken.isEmpty {
            headers["AppToken"] = self.environment.appToken
        }
        if let session = session() {
            headers["UserToken"] = session.authUserToken
        }
        */

        headers["Accept-Language"] = self.localeIdentifier
        headers["Cache-Control"] = "no-cache"

        httpServiceConfig.headers.merge(headers) { (_, new) in new }
        httpServiceConfig.decoders = Self.decoders
        httpServiceConfig.logger = self.logger
        httpServiceConfig.cacheStore = URLCache.shared
        httpServiceConfig.requestTimeoutInterval = self.requestTimeoutInterval

        return httpServiceConfig
    }
    
}
