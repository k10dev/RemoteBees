//
//  JobItem.swift
//  RemoteBeesFlow
//

public struct JobItem: Hashable, Codable, Identifiable {
    public let id: Int
    public let url: String
    public let title: String
    public let companyName: String
    public let category: String
    public let publicationDate: Date
    public let salary: String
    
    public init(
        id: Int,
        url: String,
        title: String,
        companyName: String,
        category: String,
        publicationDate: Date,
        salary: String
    ) {
        self.id = id
        self.url = url
        self.title = title
        self.companyName = companyName
        self.category = category
        self.publicationDate = publicationDate
        self.salary = salary
    }
}
