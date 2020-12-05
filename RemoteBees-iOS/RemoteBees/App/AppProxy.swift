//
//  AppProxy.swift
//  RemoteBees
//

import Foundation
import PromiseKit
import Logging
import HTTPServiceKit

struct RemoteBeesServiceLogger: HTTPServiceLogger {
    private let logger = Logger(label: "dev.beehive.RemoteBees/RemoteBeesService")

    func log(level: HTTPService.LogLevel, message: String, metadata: [String : String]?) {
        let loggerMetadata: Logger.Metadata? = metadata?.mapValues {Logger.MetadataValue(stringLiteral: $0)}
        switch level {
            case .trace:
                self.logger.trace("\(message)", metadata: loggerMetadata)
            case .debug:
                self.logger.debug("\(message)", metadata: loggerMetadata)
            case .info:
                self.logger.info("\(message)", metadata: loggerMetadata)
            case .notice:
                self.logger.notice("\(message)", metadata: loggerMetadata)
            case .warning:
                self.logger.warning("\(message)", metadata: loggerMetadata)
            case .error:
                self.logger.error("\(message)", metadata: loggerMetadata)
            case .critical:
                self.logger.critical("\(message)", metadata: loggerMetadata)
        }
    }
}

final class AppProxy {

    static let proxy = AppProxy()

    private lazy var serviceConfiguration =
        RemoteBeesServiceConfiguration(
            environment: .development,
            localeIdentifier: Locale.current.identifier,
            logger: RemoteBeesServiceLogger()
        )

    private(set) var serviceManager: ServiceManager!

    func initialize() -> Promise<Void> {
        // Mimic initialization delay
        return after(seconds: 1).map {
            self.serviceManager = try RemoteBeesServiceManager(configuration: self.serviceConfiguration)
        }
    }

}
