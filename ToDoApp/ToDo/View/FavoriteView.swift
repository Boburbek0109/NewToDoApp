//
//  FavoriteView.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 4/23/26.
//

import SwiftUI

struct FavoriteView: View {
    
    @EnvironmentObject var taskVM: TaskViewModel
 
    var body: some View{
        List{
            if taskVM.favoriteTasks.isEmpty{
                Text("No favorite task yet")
                    .foregroundStyle(Color.secondary)
            } else {
                ForEach(taskVM.favoriteTasks) { text in
                    Label(text.title, systemImage: "star.fill")
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button {
                                taskVM.toggleFavorite(for: text)
                            } label: {
                                Image(systemName: "star.slash")
                            }
                            .tint(.orange)
                        }
                }
            }
        }
        .navigationTitle("Favorite List")
    }
}

