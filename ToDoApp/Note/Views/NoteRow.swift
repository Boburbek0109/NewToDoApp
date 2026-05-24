//
//  NoteRow.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 5/23/26.
//

import SwiftUI

struct NoteRow: View {
    
    let notes: ModelNote
    
    var body: some View {
        VStack(alignment: .leading){
            
            Text(notes.title.isEmpty ? "Untitled" : notes.title)
                .font(.headline)
                .lineLimit(1)
            
            Text(notes.content)
                .font(.subheadline)
                .lineLimit(4)

            Spacer()
            
            Text(DateFormatter.dateFormatted.string(from: notes.modifiedAt))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(10)
        .frame(width: 180, height: 180, alignment: .topLeading)
        .contentShape(Rectangle())
        .clipped()
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray, lineWidth: 2)
        }
        .padding(5)
    }
}

