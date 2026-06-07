//
//  NoteViewModel.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 5/23/26.
//

import Foundation
import Combine
import SwiftData

@MainActor
final class NoteViewModel: ObservableObject {
    
    @Published private(set) var notes: [ModelNote] = []
    @Published private(set) var categories: [NoteCategory] = []
    
    private var noteContext: ModelContext
    
    init(noteContext: ModelContext) {
        self.noteContext = noteContext
        loadNotes()
        loadCategories()
    }
    
    func loadNotes() {
        let descriptor = FetchDescriptor<ModelNote>(
            sortBy: [SortDescriptor(\.modifiedAt, order: .reverse)]
        )
        notes = (try? noteContext.fetch(descriptor)) ?? []
    }
    
    func saveNotes() {
        do {
            try noteContext.save()
        } catch {
            print("Cant save note \(error)")
        }
    }
    
    private func persistChanges(){
        saveNotes()
        loadNotes()
        loadCategories()
    }
    
    func addNote(title: String, content: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty || !trimmedContent.isEmpty else { return }
        
        let note = ModelNote(
            title: trimmedTitle.isEmpty ? "Untitled" : trimmedTitle,
            content: trimmedContent
        )
        noteContext.insert(note)
        persistChanges()
    }
    
    func updateNote(_ note: ModelNote, title: String, content: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty || !trimmedContent.isEmpty else { return }
        
        note.title = trimmedTitle.isEmpty ? "Untitled" : trimmedTitle
        note.content = trimmedContent
        note.modifiedAt = Date()
        
        persistChanges()
    }
    
    func deleteNotes(_ notesToDelete: [ModelNote]) {
        for note in notesToDelete {
            noteContext.delete(note)
        }
        persistChanges()
    }
    
    func loadCategories() {
        let descriptor = FetchDescriptor<NoteCategory>(
            sortBy: [SortDescriptor(\.createdAt, order: .forward)]
        )
        
        do {
            categories = try noteContext.fetch(descriptor)
        } catch {
            print("Failed to load note categories: \(error)")
        }
    }
    
    
    func visibleNotes (for category: NoteCategory?) -> [ModelNote] {
        guard let category else {
            return notes
        }
        
        return notes.filter { $0.category?.id == category.id}
    }
    
    func category (for colorKey: String) -> NoteCategory? {
        categories.first { $0.colorKey == colorKey}
    }
    
    func createCategory(name: String, colorKey: String) -> NoteCategory? {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return nil }
        
        guard category(for: colorKey) == nil else {
            return nil
        }
        
        let category = NoteCategory(name: trimmedName, colorKey: colorKey)
        noteContext.insert(category)
        
        persistChanges()
        
        return category
    }
    
    func assignCategory(_ category: NoteCategory, to note: ModelNote){
        note.category = category
        note.modifiedAt = Date()
        
        persistChanges()
    }
    
    func assignColor(_ colorKey: String, to note: ModelNote) {
        let category = category(for: colorKey) ?? createCategory(
            name: colorKey.capitalized,
            colorKey: colorKey)
        
        guard let category else { return }
        
        assignCategory(category, to: note)
    }
    
    var usedCategories: [NoteCategory] {
        categories.filter{ category in
            notes.contains { note in
                note.category?.id == category.id
            }
        }
        .sorted { $0.createdAt < $1.createdAt}
    }
    
    func renameCategory(_ category: NoteCategory,  name: String){
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        category.name = trimmedName
        persistChanges()
    }
}
