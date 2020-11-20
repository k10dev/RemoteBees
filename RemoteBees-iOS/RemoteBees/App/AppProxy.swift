//
//  AppProxy.swift
//  RemoteBees
//

import PromiseKit

final class AppProxy {

    static let proxy = AppProxy()

    func initialize() -> Promise<Void> {
        return after(seconds: 2).map{ () }
    }

}
