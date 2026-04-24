    
//  ToDoAppApp.swift
//  ToDoApp
//
//  Created by Bobur Sobirjanov on 4/8/26.
//

import SwiftUI
import SwiftData

@main
struct ToDoApp: App {
    
    private var container: ModelContainer
    @StateObject private var vm: TaskViewModel
    
    init() {
        let container = Self.makeContainer()
        self.container = container
        _vm = StateObject(wrappedValue: TaskViewModel(context: container.mainContext))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(vm: vm)
        }
        .modelContainer(container)
    }

    private static func makeContainer() -> ModelContainer {
        let schema = Schema([ModelTask.self])
        let storeURL = makeStoreURL()
        let configuration = ModelConfiguration("ToDo", schema: schema, url: storeURL)

        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            print("Failed to load SwiftData store at \(storeURL.path): \(error)")
            removeStoreFiles(at: storeURL)

            do {
                return try ModelContainer(for: schema, configurations: [configuration])
            } catch {
                fatalError("Unrecoverable SwiftData error: \(error)")
            }
        }
    }

    private static func makeStoreURL() -> URL {
        let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!

        do {
            try FileManager.default.createDirectory(at: appSupportURL, withIntermediateDirectories: true)
        } catch {
            print("Failed to create Application Support directory: \(error)")
        }

        return appSupportURL.appendingPathComponent("ToDo.store")
    }

    private static func removeStoreFiles(at storeURL: URL) {
        let fileManager = FileManager.default
        let basePath = storeURL.path
        let pathsToRemove = [basePath, "\(basePath)-shm", "\(basePath)-wal"]

        for path in pathsToRemove where fileManager.fileExists(atPath: path) {
            do {
                try fileManager.removeItem(atPath: path)
            } catch {
                print("Failed to remove store file at \(path): \(error)")
            }
        }
    }
}


//Thread 1: Fatal error: Failed to Create ModelContainer: SwiftDataError(_error: SwiftData.SwiftDataError._Error.loadIssueModelContainer, _explanation: nil)
