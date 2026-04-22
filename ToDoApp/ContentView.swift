//
//  ContentView.swift
//  ToDoApp
//
//  Created by Bobur Sobirjanov on 4/8/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @ObservedObject var vm: TaskViewModel
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                DataDayView()
                
                ZStack {
                    RoundedRectangle(cornerSize: CGSize(width: 30, height: 30))
                        .frame(width: 360, height: 180)
                        .foregroundStyle(.gray.opacity(0.4))
                    
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        if vm.favoriteTasks.isEmpty{
                            Text("Favorites")
                                .font(.callout)
                                .opacity(0.55)
                        } else {
                            ForEach(vm.favoriteTasks) { task in
                                Label(task.title, systemImage: "star.fill")
                            }
                        }
                    }
                    .padding(.horizontal)
                    .font(.title3)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                }
                
                
                LazyVGrid(columns: columns, spacing: 10) {
                    
                    NavigationLink {
                        QuickNote(vm: vm)
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .frame(width: 180, height: 180)
                                .foregroundStyle(.gray.opacity(0.4))

                            Label("Quick Note", systemImage: "pencil")
                                .foregroundStyle(.black)
                                .font(.title3)
                        }
                    }
                    
                    
                    NavigationLink {
                        DailyTasks(vm: vm)
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .frame(width: 180, height: 180)
                                .foregroundStyle(.gray.opacity(0.4))

                            Label("Daily Tasks", systemImage: "calendar")
                                .foregroundStyle(.black)
                                .font(.title3)
                        }
                    }
                        
                        
                }
            }
            .padding(.horizontal)
        }
        .ignoresSafeArea(edges: .all)
        .onAppear(perform: vm.loadTasks)
        .onChange(of: vm.tasks) {
            vm.saveTasks()
        }
    }
}
    

#Preview {
    let container = try! ModelContainer(
        for: ModelTask.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    ContentView(vm: TaskViewModel(context: container.mainContext))
        .modelContainer(container)
}
