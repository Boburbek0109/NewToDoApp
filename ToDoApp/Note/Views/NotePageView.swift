//
//  NotePageView.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 5/25/26.
//

import SwiftUI

struct NotePageView: View {
    @EnvironmentObject var noteVM: NoteViewModel
    @State private var showNoteError = false
    @State private var noteErrorTitle = ""
    @State private var noteErrorMessage = ""
    
    let searchText: String
    let category: NoteCategory?
    var filteredNotes: [ModelNote] {
        noteVM.filteredNote(for: category, searchText: searchText)
    }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())]
    
    var body: some View {
        
        if noteVM.notes.isEmpty {
            ContentUnavailableView("Note your ideas...", systemImage: "note.text", description: Text("Tap + to add a new note"))
        } else if filteredNotes.isEmpty && !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            ContentUnavailableView("No search results", systemImage: "magnifyingglass", description: Text("Try another search"))
        } else {
            ScrollView{
                LazyVGrid(columns: columns) {
                    ForEach(filteredNotes) { note in
                        NavigationLink(destination: NoteEditorView(notes: note)) {
                            NoteRow(notes: note)
                        }
                        .buttonStyle(.plain)
                        .contextMenu{
                            NoteCategoryMenu(notes: note) {
                                noteErrorTitle = "Couldn't change category"
                                noteErrorMessage = "Your note's category hasn't changed. Please try again."
                                showNoteError = true
                            }
                            
                            Button(role: .destructive) {
                                do{
                                    try noteVM.deleteNotes([note])
                                } catch {
                                    noteErrorTitle = "Couldn't delete note"
                                    noteErrorMessage = "Your note is still here. Please try again"
                                    showNoteError = true
                                }
                            } label : {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .alert(noteErrorTitle, isPresented: $showNoteError){
                Button("OK") { }
            } message: { Text(noteErrorMessage) }
        }
    }
}
