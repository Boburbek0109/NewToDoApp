//
//  FavoriteView.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 4/23/26.
//

import SwiftUI
import SwiftData

struct FavoriteView: View {
    
    @ObservedObject var vm: TaskViewModel
 
    var body: some View{
        NavigationStack{
            List{
                if vm.favoriteTasks.isEmpty{
                    Text("No favorite task yet")
                        .foregroundStyle(Color.secondary)
                } else {
                    ForEach(vm.favoriteTasks) { text in
                        Label(text.title, systemImage: "star.fill")
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button {
                                    vm.toggleFavorite(for: text)
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
}



#Preview {
    
    let container = try! ModelContainer(
        for: ModelTask.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
    
    FavoriteView(vm: TaskViewModel(context: container.mainContext))
        .modelContainer(container)
}
