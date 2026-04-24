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
                                        vm.addTasks(from: newTask)
                                        newTask = ""
                                    }
                                
                                Button("Add") {
                                    vm.addTasks(from: newTask)
                                    newTask = ""
                                }
                            }
                        }
                        
                        if vm.tasks.isEmpty{
                            Text("Don't have any tasks today")
                                .foregroundStyle(Color.secondary)
                        } else {
                            ForEach(vm.tasks) { iList in
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
                            .onDelete(perform: vm.deleteTasks)
                        }
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
    let container = try! ModelContainer(
        for: ModelTask.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    DailyTasks(vm: TaskViewModel(context: container.mainContext))
        .modelContainer(container)
}
