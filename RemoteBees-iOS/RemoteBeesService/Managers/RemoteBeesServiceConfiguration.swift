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
                return URL(string: "https://remotive.io/api")!
        }
    }
}

public struct RemoteBeesServiceConfiguration {
    public let environment: RemoteBeesServiceEnvironment
    public let requestTimeoutInterval: TimeInterval
    public let logger: HTTPServiceLogger?
    
    public init(
        environment: RemoteBeesServiceEnvironment,
        requestTimeoutInterval: TimeInterval = 30.0,
        logger: HTTPServiceLogger? = HTTPServiceConsoleLogger()
    ) {
        self.environment = environment
        self.requestTimeoutInterval = requestTimeoutInterval
        self.logger = logger
    }
}

extension RemoteBeesServiceConfiguration {
    private static let decoders: [String: HTTPServiceDecoder] = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(formatter)

        return [
            "application/xml": jsonDecoder,
            "application/json": jsonDecoder,
        ]
    }()

    func remotive() -> HTTPService.Config {
        var httpServiceConfig = HTTPService.Config(baseUrl: self.environment.remotiveUrl)
        
        // Configure headers as needed. For example
        /*
        var headers = [String: String]()
        if !self.environment.appToken.isEmpty {
            headers["AppToken"] = self.environment.appToken
        }
        if let session = session() {
            headers["UserToken"] = session.authUserToken
        }
        httpServiceConfig.headers.merge(headers) { (_, new) in new }
        */

        httpServiceConfig.decoders = Self.decoders
        httpServiceConfig.logger = self.logger
        return httpServiceConfig
    }
}
