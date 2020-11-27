//
//  CouchbaseLite.swift
//  RemoteBees
//

import CouchbaseLiteSwift

class CouchbaseLite {
    
    private struct PreferencesDocument: Codable {
        let localeIdentifier: String
    }
    
    let database: Database
    private (set) var isClosed: Bool = false
    var isOpen: Bool {
        return !self.isClosed
    }

    init(name: String, localeIdentifier: String) throws {
        self.database = try Database(name: name)

        let prefs: PreferencesDocument = try {
            if let savedPrefs = try? self.getPreferences() {
                return savedPrefs
            }
            let newPrefs = PreferencesDocument(localeIdentifier: localeIdentifier)
            try self.savePreferences(newPrefs)
            return newPrefs
        }()

        if (localeIdentifier != prefs.localeIdentifier) {
            try self.clearUserDocuments()
            try self.savePreferences(PreferencesDocument(localeIdentifier: localeIdentifier))
        }
    }

    func clearUserDocuments() throws {
        guard self.isOpen else { return }
        try self.database.inBatch {
//            if let prefsDoc = self.database.document(withID: "<Document_Name>") {
//                try self.database.deleteDocument(prefsDoc)
//            }
            // Add more later
        }
    }

    func close() throws {
        try self.database.close()
        self.isClosed = true
    }

    private func savePreferences(_ prefs: PreferencesDocument) throws {
        guard self.isOpen else { return }
        let data = try DictionaryEncoder().encode(prefs)
        let document = MutableDocument(id: "PreferencesDocument", data: data)
        try self.database.saveDocument(document)
    }

    private func getPreferences() throws -> PreferencesDocument? {
        guard self.isOpen else { return nil }
        guard let document = self.database.document(withID: "PreferencesDocument") else { return nil }
        let dict = document.toDictionary()
        return try DictionaryDecoder().decode(PreferencesDocument.self, from: dict)
    }

}
