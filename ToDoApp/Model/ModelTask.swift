//
//  FilterType.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 4/17/26.
//

import Foundation
import SwiftData

@Model
class ModelTask: Identifiable {
    var id: String
    var title: String
    var isDone: Bool
    var isFavorite: Bool
    var byCreated: Date
    
    init(id: String = UUID().uuidString, title: String, isDone: Bool, isFavorite: Bool, byCreated: Date) {
        self.id = id
        self.title = title
        self.isDone = isDone
        self.isFavorite = isFavorite
        self.byCreated = byCreated
    }
    
}

extension ModelTask {
    static let tasksSample = [
        ModelTask(title: "Learn Harder", isDone: false, isFavorite: false, byCreated: Date()),
        ModelTask(title: "Gym", isDone: false, isFavorite: true, byCreated: Date())
    ]
    
}
