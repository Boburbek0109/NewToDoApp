//
//  NotePageView.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 5/25/26.
//

import SwiftUI

struct NotePageView: View {
    @EnvironmentObject var noteVM: NoteViewModel
    
    let searchText: String
    let category: NoteCategory?
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var filteredNotes: [ModelNote] {
        let basedNotes = noteVM.visibleNotes(for: category)
        
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
    
    var body: some View {
        
        if filteredNotes.isEmpty{
            VStack(spacing: 8) {
                Text("Note your ideas...")
                    .font(.headline)
                Text("Tap + to add a new note")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            ScrollView{
                LazyVGrid(columns: columns) {
                    ForEach(filteredNotes) { note in
                        NavigationLink(destination: NoteEditorView(notes: note)) {
                            NoteRow(notes: note)
                        }
                        .buttonStyle(.plain)
                        .contextMenu{
                            NoteCategoryMenu(notes: note)
                            
                            Button(role: .destructive) {
                                noteVM.deleteNotes([note])
                            } label : {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}
