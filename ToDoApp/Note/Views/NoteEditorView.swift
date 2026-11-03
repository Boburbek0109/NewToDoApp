//
//  NoteEditorView.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 5/23/26.
//

import SwiftUI
import SwiftData

struct NoteEditorView: View{
    @EnvironmentObject var noteVM: NoteViewModel
    @Environment(\.dismiss) private var dismiss
    private let notes: ModelNote?
    
    @State private var title = ""
    @State private var content = ""
    @State private var showNoteError = false
    
    private var hasDraf: Bool {
        !title.isEmpty || !content.isEmpty
    }
    init(notes: ModelNote? = nil){
        self.notes = notes
        _title = State(initialValue: notes?.title ?? "")
        _content = State(initialValue: notes?.content ?? "")
    }
    
    var body: some View{
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
            
            if notes == nil {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button(notes == nil ? "Add" : "Save"){
                    
                    if let notes {
                        do{
                            try noteVM.updateNote(notes, title: title, content: content)
                            dismiss()
                        } catch {
                            showNoteError = true
                        }
                    } else {
                        do{
                            try noteVM.addNote(title: title, content: content)
                            dismiss()
                        } catch {
                            showNoteError = true
                        }
                    }
                }
                .disabled(
                    title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                    content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                )
            }
        }
        .alert("Couldn’t save changes", isPresented: $showNoteError) {
            Button("OK") { }
        } message: { Text("Your draft is still here. Please try again.") }
            .interactiveDismissDisabled( notes == nil && hasDraf == true )
    }
}


#Preview {
    let editContext = try! ModelContainer(
        for: ModelNote.self, NoteCategory.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let noteVM = NoteViewModel(noteContext: editContext.mainContext)
    
    NavigationStack {
        NoteEditorView()
            .modelContainer(editContext)
            .environmentObject(noteVM)
    }
}
