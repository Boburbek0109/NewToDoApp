//
//  QuickNote.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 4/9/26.
//

import SwiftUI
import SwiftData


struct QuickNote: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var noteVM: NoteViewModel
    @State private var inputText = ""
    @State private var showNewNote = false

    var filteredNotes: [ModelNote] {
        if inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return noteVM.notes
        }
        
        let q = inputText.lowercased()
        
        return noteVM.notes.filter { note in
            note.title.lowercased().contains(q) ||
            note.content.lowercased().contains(q)
        }
    }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
            ZStack(alignment: .bottomTrailing) {
                
                if filteredNotes.isEmpty{
                    VStack(spacing: 8) {
                        Text("Write something...")
                            .font(.headline)
                        Text("Tap + to add a new notes")
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
                                .contextMenu{
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
            .navigationTitle("Notes")
            .searchable(text: $inputText, placement: .navigationBarDrawer(displayMode: .always))
            .sheet(isPresented: $showNewNote) {
                NoteEditorView()
            }
        
    }
}

#Preview {
    let noteContext = try! ModelContainer(
        for: ModelNote.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let noteVM = NoteViewModel(noteContext: noteContext.mainContext)

    QuickNote()
        .modelContainer(noteContext)
        .environmentObject(noteVM)
}
