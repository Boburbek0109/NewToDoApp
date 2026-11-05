//
//  ContentView.swift
//  ToDoApp
//
//  Created by Bobur Sobirjanov on 4/8/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    var body: some View {
        NavigationStack {
            ScrollView {
                DataDayView()
                
                VStack(spacing: 16){
                    NavigationLink {
                        QuickNote()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .frame(maxWidth: .infinity)
                                .frame(height: 180)
                                .foregroundStyle(Color(uiColor: .secondarySystemGroupedBackground))
                            
                            Label("Notes", systemImage: "pencil")
                                .foregroundStyle(.primary)
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                    }
                    
                    NavigationLink {
                        TaskListView()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .frame(maxWidth: .infinity)
                                .frame(height: 180)
                                .foregroundStyle(Color(uiColor: .secondarySystemGroupedBackground))
                            
                            Label("Tasks", systemImage: "calendar")
                                .foregroundStyle(.primary)
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                    }
                    
                    NavigationLink{
                        FavoriteView()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerSize: CGSize(width: 30, height: 30))
                                .frame(maxWidth: .infinity)
                                .frame(height: 180)
                                .foregroundStyle(Color(uiColor: .secondarySystemGroupedBackground))
                            
                            Label("Favorites", systemImage: "star.fill")
                                .foregroundStyle(.primary)
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal)
            .background(Color(uiColor: .systemGroupedBackground))
        }
    }
}
    

#Preview {
    let container = try! ModelContainer(
        for: ModelTask.self, ModelNote.self, NoteCategory.self, CalendarPlan.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let taskVM = TaskViewModel(context: container.mainContext)
    let noteVM = NoteViewModel(noteContext: container.mainContext)
    let calendarVM = CalendarPlanViewModel(calendarContext: container.mainContext)
    
    ContentView()
        .modelContainer(container)
        .environmentObject(taskVM)
        .environmentObject(noteVM)
        .environmentObject(calendarVM)
}
