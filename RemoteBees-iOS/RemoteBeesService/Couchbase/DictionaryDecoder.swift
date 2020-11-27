//
//  DictionaryDecoder.swift
//  RemoteBees
//

import Foundation

class DictionaryDecoder {
    
    static var jsonDecoder: JSONDecoder {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(formatter)
        return jsonDecoder
    }

    func decode<T>(_ type: T.Type, from dictionary: [String: Any]) throws -> T where T : Decodable {
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        return try Self.jsonDecoder.decode(type, from: data)
    }

}
