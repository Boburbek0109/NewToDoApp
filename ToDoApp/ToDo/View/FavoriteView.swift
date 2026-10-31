//
//  FavoriteView.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 4/23/26.
//

import SwiftUI

struct FavoriteView: View {
    
    @EnvironmentObject var taskVM: TaskViewModel
    @State private var errorMessage: String?
    @State private var showError = false
 
    var body: some View{
        List{
            ForEach(taskVM.favoriteTasks) { text in
                Label(text.title, systemImage: "star.fill")
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button {
                            do {
                                try taskVM.toggleFavorite(for: text)
                                errorMessage = nil
                            } catch {
                                errorMessage = error.localizedDescription
                                showError = true
                            }
                        } label: {
                            Image(systemName: "star.slash")
                        }
                        .tint(.orange)
                    }
                }
            }
        .safeAreaInset(edge: .top, content: {
            if let error = taskVM.loadErrorMessage {
                VStack(spacing: 12){
                    Text(error)
                    
                    Button("Retry") { taskVM.loadTasks() }
                }
            }
        })
        .overlay {
            if taskVM.favoriteTasks.isEmpty && taskVM.loadErrorMessage == nil {
                ContentUnavailableView(
                    "No favorite tasks yet",
                    systemImage: "star",
                    description: Text("Add your favorite tasks"))
            }
        }
        .alert("Couldn’t save changes", isPresented: $showError) {
            
        } message: { Text(errorMessage ?? "Please try again") }
        .navigationTitle("Favorite List")
    }
}

