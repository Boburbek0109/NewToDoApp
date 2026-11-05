//
//  PersistenceController.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 5/30/26.
//

import Foundation
import SwiftData

enum PersistenceError: LocalizedError{
    case applicationSupportUnavailable
    
    var errorDescription: String? {
        switch self {
        case .applicationSupportUnavailable:
            return "The app couldn’t access its data folder. Please try again."
        }
    }
}

enum PersistenceController {
    static func makeContainer(inMemory: Bool = false) throws -> ModelContainer {
        let schema = Schema([
            ModelTask.self,
            ModelNote.self,
            NoteCategory.self,
            CalendarPlan.self])
        if inMemory {
            let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            return try ModelContainer(for: schema, configurations: [configuration])
        }
        
        let storeURL = try makeStoreURL()
        let configuration = ModelConfiguration("ToDo", schema: schema, url: storeURL)

        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            print("Failed to load SwiftData store at \(storeURL.path): \(error)")
            
            throw error
        }
    }

    private static func makeStoreURL() throws -> URL {
        guard let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            throw PersistenceError.applicationSupportUnavailable }
        
        try FileManager.default.createDirectory(at: appSupportURL, withIntermediateDirectories: true)
        
        return appSupportURL.appendingPathComponent("ToDo.store")
    }
}
