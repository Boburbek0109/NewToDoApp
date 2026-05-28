//
//  TaskListView.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 4/14/26.
//

import SwiftUI

struct TaskListView: View {
    
    @EnvironmentObject var taskVM: TaskViewModel
    
    @State private var showsAddTaskField = false
    @State private var newTask = ""
    @FocusState private var isTextFieldFocused: Bool
    
    @State private var isSelected = false
    @State private var selectedTasks = Set<UUID>()
    
    var body: some View {
        VStack{
            if showsAddTaskField {
                HStack {
                    TextField("New task...", text: $newTask)
                        .textFieldStyle(.roundedBorder)
                        .focused($isTextFieldFocused)
                        .onAppear{
                            isTextFieldFocused = true
                        }
                    
                    Button("Add", action: {
                        taskVM.addTask(from: newTask)
                        newTask = ""
                    })
                }
                .padding()
            }
            CustomTabView(selectedTasks: $selectedTasks, isSelected: $isSelected)
        }
        .navigationTitle(formattedDate)
        
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    showsAddTaskField.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                
                Button{
                    withAnimation(.bouncy) {
                        isSelected.toggle()
                        selectedTasks.removeAll()                    
                    }
                } label: {
                    Image(systemName: isSelected ? "checkmark.circle" : "checklist.unchecked")
                }
                
            }
        }
    }
}

