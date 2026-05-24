//
//  TaskPageView.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 4/28/26.
//

import SwiftUI
import SwiftData

struct TaskPageView: View{
    
    @EnvironmentObject var taskVM: TaskViewModel
    
    let tab: TabModel
    @Binding var selectedTasks: Set<String>
    @Binding var isSelected: Bool
    
    var body: some View{
        List {
            if taskVM.visibleTasks(for: tab).isEmpty{
                Text(taskVM.emptyText(for: tab))
                    .foregroundStyle(Color.secondary)
            } else {
                ForEach(taskVM.visibleTasks(for: tab), id: \.id) { iList in
                    HStack {
                        if isSelected {
                            Text(iList.title)
                                .lineLimit(1)
                        } else {
                            Label {
                                Text(iList.title)
                                    .lineLimit(1)
                            } icon: {
                                Image(systemName: iList.isDone ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(iList.isDone ? .green : .red)
                            }
                        }
                        
                        Spacer()
                        
                        if isSelected {
                            Image(systemName: selectedTasks.contains(iList.id) ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(selectedTasks.contains(iList.id) ? Color.accentColor : Color.secondary)
                        }
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.18)){
                            if isSelected{
                                if selectedTasks.contains(iList.id){
                                    selectedTasks.remove(iList.id)
                                } else {
                                    selectedTasks.insert(iList.id)
                                }
                            } else {
                                taskVM.toggleDone(at: iList)
                            }
                        }
                    }
                }
                
            }
        }
        .scrollContentBackground(.hidden)
        .safeAreaInset(edge: .bottom) {
            if isSelected && !selectedTasks.isEmpty {
                HStack {
                    Button {
                        favoriteSelectedTasks()
                    } label: {
                        Label("Favorite", systemImage: "star")
                    }
                    
                    Spacer()
                    
                    Button(role: .destructive) {
                        deleteSelectedTasks()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                .padding()
                .background(.bar)
            }
        }
    }
    
    private var selectedVisibleTasks: [ModelTask] {
        taskVM.visibleTasks(for: tab).filter { selectedTasks.contains($0.id) }
    }
    
    private func favoriteSelectedTasks() {
        selectedVisibleTasks.forEach { task in
            if !task.isFavorite {
                taskVM.toggleFavorite(for: task)
            }
        }
        selectedTasks.removeAll()
        isSelected = false
    }
    
    private func deleteSelectedTasks() {
        taskVM.deleteTasks(selectedVisibleTasks)
        selectedTasks.removeAll()
        isSelected = false
    }
}


#Preview {
    let container = try! ModelContainer(
        for: ModelTask.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let taskVM = TaskViewModel(context: container.mainContext)

    TaskPageView(
        tab: .all,
        selectedTasks: .constant(Set<String>()),
        isSelected: .constant(false)
    )
        .modelContainer(container)
        .environmentObject(taskVM)
}
