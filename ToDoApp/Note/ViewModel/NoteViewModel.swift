//
//  NoteViewModel.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 5/23/26.
//

import Foundation
import Combine
import SwiftData

final class NoteViewModel: ObservableObject {
    
    @Published private(set) var notes: [ModelNote] = []
    
    private var noteContext: ModelContext
    
    init(noteContext: ModelContext) {
        self.noteContext = noteContext
        loadNotes()
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
    }
    
    func addNote(title: String, content: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty || !trimmedContent.isEmpty else { return }
        
        let notes = ModelNote(
            title: trimmedTitle.isEmpty ? "Untitled" : trimmedTitle,
            content: trimmedContent
        )
        noteContext.insert(notes)
        persistChanges()
    }
    
    func updateNote(_ notes: ModelNote, title: String, content: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty || !trimmedContent.isEmpty else { return }
        
        notes.title = trimmedTitle.isEmpty ? "Untitled" : trimmedTitle
        notes.content = trimmedContent
        notes.modifiedAt = Date()
        
        persistChanges()
    }
    
    func deleteNotes(_ notesToDelete: [ModelNote]) {
        for notes in notesToDelete {
            noteContext.delete(notes)
        }
        persistChanges()
    }
}
