//
//  NoteCategoryTabBar.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 5/25/26.
//

import SwiftUI

struct NoteCategoryTabBar: View{
    @Binding var selectedCategory: NoteCategory?
    let categories: [NoteCategory]
    
    var body: some View{
        ScrollView(.horizontal, showsIndicators: false){
            HStack{
                Button{
                    selectedCategory = nil
                } label: {
                    Text("All")
                }
                
                ForEach(categories) { category in
                    Button{
                        selectedCategory = category
                    } label: {
                        Text(category.name)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
