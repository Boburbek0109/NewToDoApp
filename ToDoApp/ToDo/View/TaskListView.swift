//
//  TaskListView.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 4/14/26.
//

import SwiftUI
import SwiftData

struct TaskListView: View {
    
    @EnvironmentObject var taskVM: TaskViewModel
    let tab: TabModel
    let showsNavigationChrome: Bool
    
    @State private var button = false
    @State private var newTask = ""
    @FocusState private var isTextFieldFocused: Bool
    
    @State private var isSelected = false
    @State private var selectedTasks = Set<String>()
    
    
    init(tab: TabModel = .all, showsNavigationChrome: Bool = true){
        self.tab = tab
        self.showsNavigationChrome = showsNavigationChrome
    }
    
    var body: some View {
        if showsNavigationChrome{
            NavigationStack {
                VStack{
                    if showsNavigationChrome && button {
                        HStack {
                            TextField("New task...", text: $newTask)
                                .textFieldStyle(.roundedBorder)
                                .focused($isTextFieldFocused)
                                .onSubmit{
                                    taskVM.addTasks(from: newTask)
                                    newTask = ""
                                }
                            
                            Button("Add", action: {
                                taskVM.addTasks(from: newTask)
                                newTask = ""
                            })
                        }
                        .padding()
                    }
                    
                }
                CustomTabView(selectedTasks: $selectedTasks, isSelected: $isSelected)
                
                .navigationTitle(formattedDate)
                .toolbar {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button {
                            button.toggle()
                            isTextFieldFocused = true
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
    }
}


#Preview {
    let container = try! ModelContainer(
        for: ModelTask.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let taskVM = TaskViewModel(context: container.mainContext)

    TaskListView()
        .modelContainer(container)
        .environmentObject(taskVM)
}
