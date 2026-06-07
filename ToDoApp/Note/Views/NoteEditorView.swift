//
//  NoteEditorView.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 5/23/26.
//

import SwiftUI

struct NoteEditorView: View{
    
    @EnvironmentObject var noteVM: NoteViewModel
    @Environment(\.dismiss) private var dismiss
    
    private let notes: ModelNote?
    @State private var title = ""
    @State private var content = ""

    
    init(notes: ModelNote? = nil){
        self.notes = notes
        _title = State(initialValue: notes?.title ?? "")
        _content = State(initialValue: notes?.content ?? "")
    }
    
    var body: some View{
        
        NavigationStack{
            VStack{
                TextField("Title", text: $title)
                    .font(.title2)
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                Divider()
                
                TextEditor(text: $content)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationTitle(notes == nil ? "New Note" : "Edit Note")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(notes == nil ? "Add" : "Save"){
                        
                        if let notes {
                            noteVM.updateNote(notes, title: title, content: content)
                        } else {
                            noteVM.addNote(title: title, content: content)
                        }
                        
                        dismiss()
                    }
                    .disabled(
                        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                        content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    )
                }
            }
        }
    }
}


#Preview {
    NoteEditorView()
}
