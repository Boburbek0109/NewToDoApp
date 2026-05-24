//
//  NoteEditorView.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 5/23/26.
//

import SwiftUI

struct NoteEditorView: View{
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var noteVM: NoteViewModel
    
    @State private var notes: ModelNote
    private var isNew: Bool
    
    init(notes: ModelNote? = nil){
        if let existing = notes{
            _notes = State(initialValue: existing)
            isNew = false
        } else {
            _notes = State(initialValue: ModelNote())
            isNew = true
        }
    }
    
    var body: some View{
        
        NavigationStack{
            VStack{
                TextField("Title", text: $notes.title)
                    .font(.title2)
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                Divider()
                
                TextEditor(text: $notes.content)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationTitle(isNew ? "New Note" : "Edit Note")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(isNew ? "Add" : "Save"){
                        if isNew {
                            noteVM.addNote(title: notes.title, content: notes.content)
                        } else {
                            noteVM.updateNote(notes, title: notes.title, content: notes.content)
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(
                        notes.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                        notes.content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    )
                }
            }
        }
    }
}


#Preview {
    NoteEditorView()
}
