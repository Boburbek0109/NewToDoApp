//
//  TaskViewModel.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 4/16/26.
//

import SwiftUI
import SwiftData
import Combine

@MainActor
final class TaskViewModel: ObservableObject {
    
    @Published private(set) var tasks: [ModelTask] = []
    @Published private(set) var loadErrorMessage: String?
    
    var favoriteTasks: [ModelTask] {
        tasks.filter { $0.isFavorite }
    }
    
    private let context: ModelContext
    
    init(context: ModelContext){
        self.context = context
        loadTasks()
    }
    
    func loadTasks() {
        let descriptor =  FetchDescriptor<ModelTask>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        
        do {
            tasks = try context.fetch(descriptor)
            loadErrorMessage = nil
        } catch {
            loadErrorMessage = error.localizedDescription
        }
    }
    
    func addTask(from text: String) throws {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        let operationContext = ModelContext(context.container)
        operationContext.autosaveEnabled = false
        let task = ModelTask(title: trimmed)
        operationContext.insert(task)
        try operationContext.save()
        loadTasks()
    }
    
    func toggleDone(at task: ModelTask) throws {
        let operationContext = ModelContext(context.container)
        operationContext.autosaveEnabled = false
        let taskID = task.id
        let predicate = #Predicate<ModelTask> { candidate in
            candidate.id == taskID }
        let descriptor =  FetchDescriptor<ModelTask> ( predicate: predicate )
        let matchingTasks = try operationContext.fetch(descriptor)
        guard let operationTask = matchingTasks.first else { throw TaskOperationError.taskNotFound }
        operationTask.isDone.toggle()
        try operationContext.save()
        
        loadTasks()
    }
    
    func toggleFavorite(for task: ModelTask) throws {
        
        let operationContext = ModelContext(context.container)
        operationContext.autosaveEnabled = false
        let taskID = task.id
        let predicate = #Predicate<ModelTask> { candidate in
            candidate.id == taskID }
        let descriptor =  FetchDescriptor<ModelTask> ( predicate: predicate )
        let matchingTasks = try operationContext.fetch(descriptor)
        guard let operationTask = matchingTasks.first else { throw TaskOperationError.taskNotFound }
        operationTask.isFavorite.toggle()
        try operationContext.save()
        
        loadTasks()
    }
    
    func addToFavorites(for tasksToFavorite: [ModelTask]) throws {
        
        let operationContext = ModelContext(context.container)
        operationContext.autosaveEnabled = false
        
        for task in tasksToFavorite {
            let taskID = task.id
            let predicate = #Predicate<ModelTask> { candidate in
                candidate.id == taskID }
            let descriptor =  FetchDescriptor<ModelTask> ( predicate: predicate )
            let matchingTasks = try operationContext.fetch(descriptor)
            guard let operationTask = matchingTasks.first else { throw TaskOperationError.taskNotFound }
            operationTask.isFavorite = true
        }
        try operationContext.save()
        loadTasks()
    }
    
    func deleteTasks(_ tasksToDelete: [ModelTask]) throws {
        
        let operationContext = ModelContext(context.container)
        operationContext.autosaveEnabled = false
        
        for task in tasksToDelete{
            let taskID = task.id
            let predicate = #Predicate<ModelTask> { candidate in
                candidate.id == taskID }
            let descriptor =  FetchDescriptor<ModelTask> ( predicate: predicate )
            let matchingTasks = try operationContext.fetch(descriptor)
            guard let operationTask = matchingTasks.first else { throw TaskOperationError.taskNotFound }
            operationContext.delete(operationTask)
        }
        try operationContext.save()
        loadTasks()
    }
    
    func visibleTasks(for tab: TabModel) -> [ModelTask] {
        switch tab {
        case .all:
            return tasks
        case .active:
            return tasks.filter { !$0.isDone }
        case .completed:
            return tasks.filter { $0.isDone }
        }
    }

    func emptyText(for tab: TabModel) -> String {
        switch tab {
        case .all:
            return "Your list starts here"
        case .active:
            return "Nothing to do right now"
        case .completed:
            return "No completed tasks yet"
        }
    }
    
}

enum TaskOperationError: LocalizedError {
    case taskNotFound
    
    var errorDescription: String? {
        switch self {
        case .taskNotFound:
            return "This task could not be found. Reload the list and try again."
        }
    }
}
