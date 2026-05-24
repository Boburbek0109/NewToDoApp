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
}
