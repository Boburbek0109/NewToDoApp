//
//  ModelNote.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 5/22/26.
//

import Foundation
import SwiftData

@Model
final class ModelNote: Identifiable{
    var id: UUID
    var title: String
    var content: String
    var createdAt: Date
    var modifiedAt: Date
    var category: NoteCategory?
    
    init(
        id: UUID = UUID(),
        title: String = "",
        content: String = "",
        createdAt: Date = Date(),
        modifiedAt: Date = Date(),
        category: NoteCategory? = nil
    ){
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
        self.category = category
    }
}
