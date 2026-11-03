//
//  QuickNote.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 4/9/26.
//

import SwiftUI
import SwiftData


struct QuickNote: View {
    @EnvironmentObject var noteVM: NoteViewModel

    @State private var showNewNote = false
    @State private var isSearchPresented = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack{
                if let message = noteVM.notesLoadErrorMessage {
                    Text(message)
                    Button("Retry") {
                        noteVM.loadNotes()
                    }
                }
                if let categoryMessage = noteVM.categoriesLoadErrorMessage {
                    Text(categoryMessage)
                    Button("Retry") {
                        noteVM.loadCategories()
                    }
                }
                if noteVM.notesLoadErrorMessage == nil || !noteVM.notes.isEmpty {
                    if noteVM.notes.isEmpty {
                        NoteCategoryPagerView(searchText: noteVM.debouncedSearchText)
                    } else {
                        NoteCategoryPagerView(searchText: noteVM.debouncedSearchText)
                            .searchable(text: $noteVM.inputText, isPresented: $isSearchPresented, placement: .toolbar)
                            .searchToolbarBehavior(.minimize)
                    }
                }
            }
            if !isSearchPresented {
                Button( action: {
                    showNewNote = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                        .padding()
                        .background(Color(.blue))
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .padding()
            }
        }
        .navigationTitle("Notes")
        .toolbar{
            if noteVM.notes.isEmpty {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Search", systemImage: "magnifyingglass") {
                        isSearchPresented = true
                    }
                    .disabled(noteVM.notes.isEmpty)
                }
            } else {
                DefaultToolbarItem(kind: .search, placement: .topBarTrailing)
            }
        }
        .sheet(isPresented: $showNewNote) {
            NavigationStack{
                NoteEditorView()
            }
        }
    }
}

#Preview {
    let noteContext = try! ModelContainer(
        for: ModelNote.self, NoteCategory.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let noteVM = NoteViewModel(noteContext: noteContext.mainContext)

    QuickNote()
        .modelContainer(noteContext)
        .environmentObject(noteVM)
}
