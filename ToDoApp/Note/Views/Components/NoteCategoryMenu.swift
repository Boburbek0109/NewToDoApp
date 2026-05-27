//
//  NoteCategoryMenu.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 5/25/26.
//

import SwiftUI

struct NoteCategoryMenu: View {
    @EnvironmentObject var noteVM: NoteViewModel
    
    let notes: ModelNote
    
    var body: some View {
        Section("Color"){
            ForEach(NoteCategoryColor.availableKeys, id: \.self){ colorKey in
                Button{
                    noteVM.assignColor(colorKey, to: notes)
                } label: {
                    HStack{
                        Circle()
                            .fill(NoteCategoryColor.color(for: colorKey))
                            .frame(width: 12, height: 12)
                        
                        Text(colorKey.capitalized)
                    }
                }
            }
        }
    }
}
