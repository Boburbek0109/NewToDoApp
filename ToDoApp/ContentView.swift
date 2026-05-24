//
//  ContentView.swift
//  ToDoApp
//
//  Created by Bobur Sobirjanov on 4/8/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @EnvironmentObject var taskVM: TaskViewModel
    @EnvironmentObject var noteVM: NoteViewModel
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                DataDayView()
                
                NavigationLink{
                    FavoriteView()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerSize: CGSize(width: 30, height: 30))
                                .frame(maxWidth: .infinity)
                                .frame(height: 180)
                                .foregroundStyle(.gray.opacity(0.4))
                                
                            Label("Favorites", systemImage: "star.fill")
                                .foregroundStyle(.black)
                                .font(.title)
                            
                        }
                }
                
                
                LazyVGrid(columns: columns, spacing: 10) {
                    
                    NavigationLink {
                        QuickNote()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .frame(width: 180, height: 180)
                                .foregroundStyle(.gray.opacity(0.4))

                            Label("Note your plans", systemImage: "pencil")
                                .foregroundStyle(.black)
                                .font(.title3)
                        }
                    }
                    
                    
                    NavigationLink {
                        TaskListView()
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
    }
}
    

#Preview {
    let container = try! ModelContainer(
        for: ModelTask.self, ModelNote.self,
        
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let taskVM = TaskViewModel(context: container.mainContext)
    let noteVM = NoteViewModel(noteContext: container.mainContext)
    
    ContentView()
        .modelContainer(container)
        .environmentObject(taskVM)
        .environmentObject(noteVM)
}
