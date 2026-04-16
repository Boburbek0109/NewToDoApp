//
//  TaskViewModel.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 4/16/26.
//

import SwiftUI
import Combine

class TaskViewModel: ObservableObject {
    
    @Published var tasks: [NewToDoTask] = []
    @Published var inputText = ""
    
    
    private let storageKey = "items_list"
    
    var favoriteTasks: [NewToDoTask] {
        tasks.filter { $0.isFavorite }
    }
    
    struct NewToDoTask: Identifiable, Codable, Equatable {
        let id: UUID
        var name: String
        var is​Done: Bool
        var isFavorite: Bool

        init(id: UUID = UUID(), name: String, is​Done: Bool, isFavorite: Bool) {
            self.id = id
            self.name = name
            self.is​Done = is​Done
            self.isFavorite = isFavorite
        }
    }
    
    
    func saveItems() {
        guard let encodedData = try? JSONEncoder().encode(tasks) else { return }
        UserDefaults.standard.set(encodedData, forKey: storageKey)
    }
    
    
    func loadItems() {
        guard
            let data = UserDefaults.standard.data(forKey: storageKey),
            let savedItems = try? JSONDecoder().decode([NewToDoTask].self, from: data)
        else { return }
        
        tasks = savedItems
    }

    
    func saveTask() {
        let trimmedText = inputText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedText.isEmpty else { return }

        tasks.insert(NewToDoTask(name: trimmedText, is​Done: false, isFavorite: false), at: 0)
        inputText = ""
    }
    
    
    func addTask(from text: String) {
        let trimmedTask = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTask.isEmpty else { return }

        tasks.insert(NewToDoTask(name: trimmedTask, is​Done: false, isFavorite: false), at: 0)
        saveItems()
    }
    
    
    func toggleDone(at task: NewToDoTask) {
        guard let index = tasks.firstIndex(of: task) else { return }
        tasks[index].is​Done.toggle()
        saveItems()
    }
    
    
    func toggleFavorite(for task: NewToDoTask) {
        guard let index = tasks.firstIndex(of: task) else { return }
        tasks[index].isFavorite.toggle()
        saveItems()
    }
    
    func deleteItem(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
        saveItems()
    }
    
}

