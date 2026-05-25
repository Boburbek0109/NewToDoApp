//
//  NoteCategory.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 5/25/26.
//

import SwiftUI
import SwiftData

@Model
final class NoteCategory: Identifiable{
    var id: UUID
    var name: String
    var colorKey: String
    var createdAt: Date
    
    init(
        id: UUID = UUID(),
        name: String = "",
        colorKey: String = "",
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.colorKey = colorKey
        self.createdAt = createdAt
    }
}

enum NoteCategoryColor {
    static let availableKeys = ["red", "orange", "yellow", "green", "blue", "purple"]
    
    static func color(for key: String) -> Color{
        switch key {
        case "red":
            return .red
        case "orange":
            return .orange
        case "yellow":
            return .yellow
        case "green":
            return .green
        case "blue":
            return .blue
        case "purple":
            return .purple
        default: return .gray
            
        }
    }
}
