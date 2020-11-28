//
//  RemoteBeesContentService.swift
//  RemoteBees
//

import UIKit
import PromiseKit
import HTTPServiceKit

class RemoteBeesContentService: HTTPService, ContentService {
    
    func getContent(url: URL) -> Promise<Data?> {
        let criteria = CacheCriteria(policy: CachePolicy.useAge, age: CacheAge.immortal.interval)
        let p: Promise<Result?> = self.get(route: url.absoluteString, cacheCriteria: criteria)
        return p.map(on: DispatchQueue.global()) { result in result?.body }
    }

    func getImage(url: URL) -> Promise<UIImage?> {
        self.getContent(url: url).map(on: DispatchQueue.global()) {
            guard let data = $0 else { return nil }
            return UIImage(data: data)
        }
    }

}
