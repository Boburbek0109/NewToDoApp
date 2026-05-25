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
    
    @State private var selectedCategory: NoteCategory? = nil
    @State private var inputText = ""
    @State private var showNewNote = false

    var body: some View {
            ZStack(alignment: .bottomTrailing) {
                VStack{
                    
                    NoteCategoryTabBar(selectedCategory: $selectedCategory,
                                       categories: noteVM.usedCategories)
                    
                    NotePageView(
                        searchText: inputText,
                        category: selectedCategory)
                    
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
