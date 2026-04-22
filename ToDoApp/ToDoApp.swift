    
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
        let container = try! ModelContainer(for: ModelTask.self)
        self.container = container
        _vm = StateObject(wrappedValue: TaskViewModel(context: container.mainContext))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(vm: vm)
        }
        .modelContainer(container)
    }
}
