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
class TaskViewModel: ObservableObject {
    
    @Published var tasks: [ModelTask] = []
    
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
            sortBy: [SortDescriptor(\.byCreated, order: .reverse)]
        )
        tasks = (try? context.fetch(descriptor)) ?? []
    }
    
    func saveTasks() {
        do {
            try context.save()
        } catch {
            print("Cant save task \(error)")
        }
    }
    
    func addTasks(from text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        let task = ModelTask(title: trimmed, isDone: false, isFavorite: false, byCreated: Date())
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
    
    func deleteTasks(at offsets: IndexSet) {
        for index in offsets{
            context.delete(tasks[index])
        }
        persistChanges()
    }
    
    func moveTasks(from: IndexSet, to: Int){
        tasks.move(fromOffsets: from, toOffset: to)
    }
    
    private func persistChanges(){
        saveTasks()
        loadTasks()
    }
}
