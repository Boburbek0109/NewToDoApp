//
//  TaskPageView.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 4/28/26.
//

import SwiftUI

struct TaskPageView: View{
    
    @EnvironmentObject var taskVM: TaskViewModel
    
    @State private var errorMessage: String?
    @State private var showError = false
    let tab: TabModel
    @Binding var selectedTasks: Set<UUID>
    @Binding var isSelected: Bool
    
    var body: some View{
        List {
            ForEach(taskVM.visibleTasks(for: tab), id: \.id) { iList in
                HStack {
                    if isSelected {
                        Text(iList.title)
                    } else {
                        Label {
                            Text(iList.title)
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
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.18)){
                        if isSelected{
                            if selectedTasks.contains(iList.id){
                                selectedTasks.remove(iList.id)
                            } else {
                                selectedTasks.insert(iList.id)
                            }
                        } else {
                            do {
                                try taskVM.toggleDone(at: iList)
                                errorMessage = nil
                            } catch {
                                errorMessage = error.localizedDescription
                                showError = true
                            }
                        }
                    }
                }
            }
        }
        .overlay{
            if taskVM.visibleTasks(for: tab).isEmpty && taskVM.loadErrorMessage == nil {
                ContentUnavailableView(
                    taskVM.emptyText(for: tab),
                    systemImage: "checklist",
                    description: tab == .all ? Text("Tap + to add your first task.") : nil)
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
        .alert(isPresented: $showError) {
            Alert(title: Text("Couldn’t save changes"), message: Text(errorMessage ?? "Please try again"))
        }
    }
    
    private var selectedVisibleTasks: [ModelTask] {
        taskVM.visibleTasks(for: tab).filter { selectedTasks.contains($0.id) }
    }
    
    private func favoriteSelectedTasks() {
        do {
            try taskVM.addToFavorites(for: selectedVisibleTasks)
            selectedTasks.removeAll()
            isSelected = false
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
    private func deleteSelectedTasks() {
        do {
            try taskVM.deleteTasks(selectedVisibleTasks)
            selectedTasks.removeAll()
            isSelected = false
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}
