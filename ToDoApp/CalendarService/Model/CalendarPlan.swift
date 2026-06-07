//
//  CalendarPlan.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 6/1/26.
//

import Foundation
import SwiftData

@Model
final class CalendarPlan: Identifiable{
    var id: UUID
    var title: String
    var details: String
    var startDate: Date
    var endDate: Date
    var colorKey: String
    
    init(
        id: UUID = UUID(),
        title: String = "",
        details: String = "",
        startDate: Date = Date(),
        endDate: Date = Date(),
        colorKey: String = "red"
    ) {
        self.id = id
        self.title = title
        self.details = details
        self.startDate = startDate
        self.endDate = endDate
        self.colorKey = colorKey
    }
}

//
//let dateFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateFormat = "yyyy-MM-dd"
//    return formatter
//}()

