//
//  ContentService.swift
//  RemoteBees
//

import UIKit
import PromiseKit

public protocol ContentService {

    func getContent(url: URL) -> Promise<Data?>

    func getImage(url: URL) -> Promise<UIImage?>

}
