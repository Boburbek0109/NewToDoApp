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
    @Published private(set) var notesLoadErrorMessage: String?
    @Published private(set) var categoriesLoadErrorMessage: String?
    
    @Published var inputText = ""
    @Published private(set) var debouncedSearchText = ""
    
    private var noteContext: ModelContext
    private var cancellables = Set<AnyCancellable>()
    
    init(noteContext: ModelContext) {
        self.noteContext = noteContext

        $inputText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.debouncedSearchText = text
            }
            .store(in: &cancellables)

        loadNotes()
        loadCategories()
    }
    
    func loadNotes() {
        let descriptor = FetchDescriptor<ModelNote>(
            sortBy: [SortDescriptor(\.modifiedAt, order: .reverse)])
        do {
            notes = try noteContext.fetch(descriptor)
            notesLoadErrorMessage = nil
        } catch {
            notesLoadErrorMessage = ("Couldn't load notes. Please try again.")
            print("Failed to load notes: \(error)")
        }
    }
    
    func addNote(title: String, content: String) throws {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty || !trimmedContent.isEmpty else { return }
        let saveContext = ModelContext(noteContext.container)
        saveContext.autosaveEnabled = false
        let note = ModelNote(
            title: trimmedTitle.isEmpty ? "Untitled" : trimmedTitle,
            content: trimmedContent
        )
        saveContext.insert(note)
        try saveContext.save()
        loadNotes()
    }
    
    func updateNote(_ note: ModelNote, title: String, content: String) throws {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty || !trimmedContent.isEmpty else { return }
        
        let updateContext = ModelContext(noteContext.container)
        updateContext.autosaveEnabled = false
        let noteID = note.id
        let predicate = #Predicate<ModelNote> { cont in
            cont.id == noteID
        }
        let descriptor =  FetchDescriptor<ModelNote> ( predicate: predicate )
        let matchingNotes = try updateContext.fetch(descriptor)
        guard let savedNote = matchingNotes.first else { throw NSError(domain: "Note Update", code: 1) }
                
        savedNote.title = trimmedTitle.isEmpty ? "Untitled" : trimmedTitle
        savedNote.content = trimmedContent
        savedNote.modifiedAt = Date()
        
        try updateContext.save()
        note.title = savedNote.title
        note.content = savedNote.content
        note.modifiedAt = savedNote.modifiedAt
        loadNotes()
    }
    
    func deleteNotes(_ notesToDelete: [ModelNote]) throws {
        let deleteContext = ModelContext(noteContext.container)
        deleteContext.autosaveEnabled = false
        for note in notesToDelete {
            let noteID = note.id
            let predicate = #Predicate<ModelNote> { cont in
                cont.id == noteID
            }
            let descriptor =  FetchDescriptor<ModelNote> ( predicate: predicate )
            let matchingNotes = try deleteContext.fetch(descriptor)
            guard let savedNote = matchingNotes.first else { throw NSError(domain: "Note Delete", code: 1) }
            deleteContext.delete(savedNote)
        }
        try deleteContext.save()
        loadNotes()
    }
    
    func loadCategories() {
        let descriptor = FetchDescriptor<NoteCategory>(
            sortBy: [SortDescriptor(\.createdAt, order: .forward)])
        do {
            categories = try noteContext.fetch(descriptor)
            categoriesLoadErrorMessage = nil
        } catch {
            categoriesLoadErrorMessage = "Couldn't load categories. Please try again."
            print("Failed to load note categories: \(error)")
        }
    }
    
    func visibleNotes (for category: NoteCategory?) -> [ModelNote] {
        guard let category else {
            return notes
        }
        return notes.filter { $0.category?.id == category.id}
    }
    
    func filteredNote(for category: NoteCategory?, searchText: String) -> [ModelNote] {
        let basedNotes = visibleNotes(for: category)
        
        let trimmedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedSearch.isEmpty else {
            return basedNotes
        }
        
        let q = trimmedSearch.lowercased()
        
        return basedNotes.filter { note in
            note.title.lowercased().contains(q) ||
            note.content.lowercased().contains(q)
        }
    }
    
    func category (for colorKey: String) -> NoteCategory? {
        categories.first { $0.colorKey == colorKey}
    }
    
    func assignColor(_ colorKey: String, to note: ModelNote) throws {
        
        let assignmentContext = ModelContext(noteContext.container)
        assignmentContext.autosaveEnabled = false
        let noteID = note.id
        let notePredicate = #Predicate<ModelNote> { assignCo in
            assignCo.id == noteID
        }
        let noteDescriptor = FetchDescriptor<ModelNote>(predicate: notePredicate)
        let matchingNote = try assignmentContext.fetch(noteDescriptor)
        guard let savedNote = matchingNote.first else { throw NSError(domain: "Category Assignment", code: 1) }
        
        let categoryPredicate = #Predicate<NoteCategory> { category in
            category.colorKey == colorKey
        }
        let categoryDescrpt = FetchDescriptor<NoteCategory>(predicate: categoryPredicate)
        let matchingCategory = try assignmentContext.fetch(categoryDescrpt)
        let savedCategory: NoteCategory
        if let existingCategory = matchingCategory.first {
            savedCategory = existingCategory
        } else {
            savedCategory = NoteCategory(name: colorKey.capitalized, colorKey: colorKey)
            assignmentContext.insert(savedCategory)
        }
        savedNote.category = savedCategory
        savedNote.modifiedAt = Date()
        try assignmentContext.save()
        loadCategories()
        if let displayCategory = category(for: colorKey) {
            note.category = displayCategory
            note.modifiedAt = savedNote.modifiedAt
        }
        loadNotes()
    }
    
    var usedCategories: [NoteCategory] {
        categories.filter{ category in
            notes.contains { note in
                note.category?.id == category.id
            }
        }
        .sorted { $0.createdAt < $1.createdAt}
    }
    
    func renameCategory(_ category: NoteCategory,  name: String) throws {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        let renameContext = ModelContext(noteContext.container)
        renameContext.autosaveEnabled = false
        let categoryID = category.id
        let predicate = #Predicate<NoteCategory> { categoryName in
            categoryName.id == categoryID
        }
        let description = FetchDescriptor<NoteCategory> (predicate: predicate)
        let renameNote = try renameContext.fetch(description)
        guard let savedCategory = renameNote.first else { throw NSError(domain: "Category Rename", code: 1)}
        
        savedCategory.name = trimmedName
        try renameContext.save()
        category.name = savedCategory.name
        loadCategories()
    }
}
