    
//  ToDoAppApp.swift
//  ToDoApp
//
//  Created by Bobur Sobirjanov on 4/8/26.
//

import SwiftUI
import SwiftData

enum StartupState {
    case ready(ModelContainer)
    case failed(String)
}

@main
struct ToDoApp: App {
    
    @State private var startupState: StartupState
    
    init() {
        do {
            let container = try PersistenceController.makeContainer()
            _startupState = State(initialValue: StartupState.ready(container))
        } catch {
            _startupState = State(initialValue: StartupState.failed(error.localizedDescription))
        }
    }
    
    func retryOpeningStore() {
        do {
            let container = try PersistenceController.makeContainer()
            startupState = StartupState.ready(container)
        } catch {
            startupState = StartupState.failed(error.localizedDescription)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            switch startupState {
                
            case .ready(let container):
                ReadyAppView(container: container)
                
            case .failed(let message):
                VStack(spacing: 8){
                    Text("Couldn’t open your data")
                    
                    Text(message)
                    
                    Button("Retry") {
                        retryOpeningStore()
                    }
                    .buttonStyle(.bordered)
                    .glassEffect(.regular)
                }.padding()
            }
        }
    }
}

struct ReadyAppView: View {
    
    private var container: ModelContainer
    @StateObject private var taskVM: TaskViewModel
    @StateObject private var noteVM: NoteViewModel
    @StateObject private var calendarVM: CalendarPlanViewModel
    
    init(container: ModelContainer) {
        self.container = container
        _taskVM = StateObject(wrappedValue: TaskViewModel(context: container.mainContext))
        _noteVM = StateObject(wrappedValue: NoteViewModel(noteContext: container.mainContext))
        _calendarVM = StateObject(wrappedValue: CalendarPlanViewModel(calendarContext: container.mainContext))
    }
    
    var body: some View {
        ContentView()
            .environmentObject(taskVM)
            .environmentObject(noteVM)
            .environmentObject(calendarVM)
            .modelContainer(container)
    }
}
