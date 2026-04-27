//
//  DailyTasks.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 4/14/26.
//

import SwiftUI
import SwiftData

private var formattedDate: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM d"
    return formatter.string(from: Date())
}

struct DailyTasks: View {
    
    @EnvironmentObject var vm: TaskViewModel
    let tab: TabModel
    let showsNavigationChrome: Bool
    
    @State private var button = false
    @State private var newTask = ""
    @FocusState private var isTextFieldFocused: Bool
    
    init(tab: TabModel = .all, showsNavigationChrome: Bool = true){
        self.tab = tab
        self.showsNavigationChrome = showsNavigationChrome
    }
    
    var body: some View {
        if showsNavigationChrome{
            NavigationStack {
                fullDailyTasksView
                    .navigationTitle(formattedDate)
            }
        } else {
            taskList
        }
    }

    private var fullDailyTasksView: some View {
        ZStack{
//                Color(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
//                    .ignoresSafeArea(.all)

            VStack {
                taskList
            }

            Button {
                button = true
                isTextFieldFocused = true
            } label: {
                Image(systemName: "plus")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .padding(.bottom, 30)
            .padding(.trailing, 20)
            .font(.system(size: 40))
            .buttonBorderShape(.circle)
            .buttonStyle(.glass)
            .shadow(radius: 8, x: 4, y: 4)
        }
    }

    private var taskList: some View {
        List {
            if showsNavigationChrome && button {
                HStack {
                    TextField("New task...", text: $newTask)
                        .background(Color(#colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)))
                        .textFieldStyle(.roundedBorder)
                        .focused($isTextFieldFocused)
                        .onSubmit(addTask)

                    Button("Add", action: addTask)
                }
            }

            if visibleTasks.isEmpty{
                Text(emptyText)
                    .foregroundStyle(Color.secondary)
            } else {
                ForEach(visibleTasks) { iList in
                    HStack {
                        Label {
                            Text(iList.title)
                                .lineLimit(1)
                        } icon: {
                            Image(systemName: iList.isDone ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(iList.isDone ? .green : .red)
                        }
                    }
                    .onTapGesture {
                        withAnimation(.bouncy){
                            vm.toggleDone(at: iList)
                        }
                    }

                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button {
                            vm.toggleFavorite(for: iList)
                        } label: {
                            Image(systemName: iList.isFavorite ? "star.fill" : "star")
                        }
                        .tint(iList.isFavorite ? .green : .blue)
                    }
                }
                .onDelete { offsets in
                    let tasksToDelete = offsets.map { visibleTasks[$0] }
                    vm.deleteTasks(tasksToDelete)
                }
            }
        }
        .scrollContentBackground(.hidden)
    }

    private var visibleTasks: [ModelTask] {
        switch tab {
        case .all:
            return vm.tasks
        case .active:
            return vm.tasks.filter { !$0.isDone }
        case .completed:
            return vm.tasks.filter { $0.isDone }
        }
    }

    private var emptyText: String {
        switch tab {
        case .all:
            return "Don't have any tasks today"
        case .active:
            return "No active tasks"
        case .completed:
            return "No completed tasks"
        }
    }

    private func addTask() {
        vm.addTasks(from: newTask)
        newTask = ""
    }
}

#Preview {
    let container = try! ModelContainer(
        for: ModelTask.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let vm = TaskViewModel(context: container.mainContext)

    DailyTasks()
        .modelContainer(container)
        .environmentObject(vm)
}
