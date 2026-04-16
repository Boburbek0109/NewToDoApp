//
//  DailyTasks.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 4/14/26.
//

import SwiftUI

private var formattedDate: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM d"
    return formatter.string(from: Date())
}

struct DailyTasks: View {
    
    @ObservedObject var vm: TaskViewModel
    
    @State private var button = false
    @State private var newTask = ""
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        NavigationStack {
            ZStack{
                VStack {
                    List {
                        if button {
                            HStack {
                                TextField("New task...", text: $newTask)
                                    .background(Color(#colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)))
                                    .textFieldStyle(.roundedBorder)
                                    .focused($isTextFieldFocused)
                                    .onSubmit {
                                        vm.addTask(from: newTask)
                                    }

                                Button("Add") {
                                    vm.addTask(from: newTask)
                                }
                            }
                        }

                        ForEach(vm.tasks) { task in
                            HStack {
                                Text(task.name)

                                Spacer()

                                Image(systemName: task.is​Done ? "checkmark.circle.fill" : "circle")
                                    .onTapGesture {
                                        vm.toggleDone(at: task)
                                    }
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button {
                                    vm.toggleFavorite(for: task)
                                } label: {
                                    Image(systemName: task.isFavorite ? "star.fill" : "star")
                                }
                                .tint(task.isFavorite ? .green : .blue)
                            }
                        }
                        .onDelete(perform: vm.deleteItem)
                    }
                }
                .navigationTitle(formattedDate)
                    

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
    }
}

#Preview {
    let vm = TaskViewModel()
    DailyTasks(vm: vm)
}
