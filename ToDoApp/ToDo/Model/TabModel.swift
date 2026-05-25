//
//  TabModel.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 4/25/26.
//

import Foundation

enum TabModel: String, CaseIterable {
    case all = "All"
    case active = "Active"
    case completed = "Complete"
    
    var systemImage: String{
        switch self {
        case .all:
            return "text.page"
        case .active:
            return "hourglass"
        case .completed:
            return "checkmark.circle"
        }
    }
}
