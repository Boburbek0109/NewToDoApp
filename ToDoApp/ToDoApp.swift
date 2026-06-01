    
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
    @StateObject private var taskVM: TaskViewModel
    @StateObject private var noteVM: NoteViewModel
    
    init() {
        let container = PersistenceController.makeContainer()
        self.container = container
        _taskVM = StateObject(wrappedValue: TaskViewModel(context: container.mainContext))
        _noteVM = StateObject(wrappedValue: NoteViewModel(noteContext: container.mainContext))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(taskVM)
                .environmentObject(noteVM)
        }
        .modelContainer(container)
    }
}
