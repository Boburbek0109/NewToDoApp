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

struct NewToDoTask: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var isDone: Bool

    init(id: UUID = UUID(), name: String, isDone: Bool) {
        self.id = id
        self.name = name
        self.isDone = isDone
    }
}

struct DailyTasks: View {
    @State private var button = false
    @State private var newTask = ""
    @FocusState private var isTextFieldFocused: Bool
    @Binding var tasks: [NewToDoTask]

    var body: some View {
        NavigationStack {
            ZStack{
                VStack {
                    List {
                        if button {
                            HStack {
                                TextField("New task...", text: $newTask)
                                    .textFieldStyle(.roundedBorder)
                                    .focused($isTextFieldFocused)
                                    .onSubmit {
                                        addTask()
                                    }

                                Button("Add") {
                                    addTask()
                                }
                            }
                        }

                        ForEach($tasks) { $task in
                            HStack {
                                Text(task.name)

                                Spacer()

                                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                                    .onTapGesture {
                                        task.isDone.toggle()
                                    }
                            }
                        }
                        .onDelete(perform: deleteItem)
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

    private func addTask() {
        let trimmedTask = newTask.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTask.isEmpty else { return }

        tasks.insert(NewToDoTask(name: trimmedTask, isDone: false), at: 0)
        newTask = ""
        button = false
        isTextFieldFocused = false
    }
    
    

    private func deleteItem(indexSet: IndexSet) {
        tasks.remove(atOffsets: indexSet)
    }
}

#Preview {
    @Previewable @State var tasks: [NewToDoTask] = []
    DailyTasks(tasks: $tasks)
}
