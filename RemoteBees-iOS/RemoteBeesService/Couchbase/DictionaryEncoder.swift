/***************************************************************************
 * This source file is part of the RemoteBees open source project.         *
 *                                                                         *
 * Licensed under the MIT License. See LICENSE for license information     *
 ***************************************************************************/

import Foundation

class DictionaryEncoder {
    
    static var jsonEncoder: JSONEncoder {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .formatted(formatter)
        return jsonEncoder
    }

    func encode<T>(_ value: T) throws -> [String: Any] where T : Encodable {
        let data = try Self.jsonEncoder.encode(value)
        return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
    }

}
