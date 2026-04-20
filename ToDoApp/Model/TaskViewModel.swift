//
//  TaskViewModel.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 4/16/26.
//

import SwiftUI
import Combine

struct NewToDoTask: Identifiable,  Codable, Equatable {
    let id: String
    let title: String
    var isDone: Bool
    var isFavorite: Bool
    
    init(id: String = UUID().uuidString, title: String, isDone: Bool, isFavorite: Bool) {
        self.id = id
        self.title = title
        self.isDone = isDone
        self.isFavorite = isFavorite
    }
    
    func updateTasks() -> NewToDoTask{
        return NewToDoTask(id: id, title: title, isDone: !isDone, isFavorite: !isFavorite)
    }
}


class TaskViewModel: ObservableObject {
    
    @Published var tasks: [NewToDoTask] = [] {
        didSet {
            saveItem()
        }
    }
    
    @Published var inputText = ""
    
    
    private let storageKey = "items_list"
    
    var favoriteTasks: [NewToDoTask] {
        tasks.filter { $0.isFavorite }
    }
    
    
    
    func saveItem() {
        guard let encodedData = try? JSONEncoder().encode(tasks) else { return }
        UserDefaults.standard.set(encodedData, forKey: storageKey)
    }
    
    
    func loadTasks() {
        guard
            let data = UserDefaults.standard.data(forKey: storageKey),
            let savedItems = try? JSONDecoder().decode([NewToDoTask].self, from: data)
        else { return }
        
        self.tasks = savedItems
    }
    
    
    func saveTasks() {
        
        let trimmedText = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedText.isEmpty else { return }
        
        tasks.insert(NewToDoTask(title: trimmedText, isDone: false, isFavorite: false), at: 0)
        

    }
    
    
    func addTasks(from text: String) {
        let trimmedTask = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTask.isEmpty else { return }
        
        tasks.insert(NewToDoTask(title: trimmedTask, isDone: false, isFavorite: false), at: 0)
        saveItem()
    }
    
    
    func toggleDone(at task: NewToDoTask) {
        guard let index = tasks.firstIndex(of: task) else { return }
            tasks[index].isDone.toggle()
        saveItem()
    }
    
    
    func toggleFavorite(for task: NewToDoTask) {
        guard let index = tasks.firstIndex(of: task) else { return }
        tasks[index].isFavorite.toggle()
        saveItem()
    }
    
    func deleteTasks(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
        saveItem()
    }
    
    func updateTasks(task: NewToDoTask){
        
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task.updateTasks()
        }
    }
    
    func moveTasks(from: IndexSet, to: Int){
        tasks.move(fromOffsets: from, toOffset: to)
    }
}

