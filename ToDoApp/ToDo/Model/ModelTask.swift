//
//  ModelTask.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 4/17/26.
//

import Foundation
import SwiftData

@Model
final class ModelTask: Identifiable {
    var id = UUID()
    var title: String
    var isDone: Bool
    var isFavorite: Bool
    var createdAt: Date
    
    init(
        id: UUID = UUID(),
        title: String,
        isDone: Bool = false,
        isFavorite: Bool = false,
        createdAt: Date = Date(),
    ) {
        self.id = id
        self.title = title
        self.isDone = isDone
        self.isFavorite = isFavorite
        self.createdAt = createdAt
    }
    
}
