//
//  ServiceManager.swift
//  RemoteBees
//

public protocol ServiceManager {
    
    var beehiveService: BeehiveService { get }

    var contentService: ContentService { get }

}
