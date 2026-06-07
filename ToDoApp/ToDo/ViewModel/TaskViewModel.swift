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
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        
        do {
            tasks = try context.fetch(descriptor)
        } catch {
            print("Failed to load task: \(error)")
        }
    }
    
    func saveTasks() {
        do {
            try context.save()
        } catch {
            print("Cant save task \(error)")
        }
    }
    
    func addTask(from text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        let task = ModelTask(title: trimmed)
        context.insert(task)
        persistChanges()
    }
    
    
    func toggleDone(at task: ModelTask) {
        task.isDone.toggle()
        persistChanges()
    }
    
    
    func toggleFavorite(for task: ModelTask) {
        task.isFavorite.toggle()
        persistChanges()
    }
    
    func deleteTasks(_ tasksToDelete: [ModelTask]) {
        for task in tasksToDelete{
            context.delete(task)
        }
        persistChanges()
    }
    
    func visibleTasks (for tab: TabModel) -> [ModelTask] {
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
            return "Don't have any tasks today"
        case .active:
            return "No active tasks"
        case .completed:
            return "No completed tasks"
        }
    }
    
    private func persistChanges(){
        saveTasks()
        loadTasks()
    }
    
    
}
