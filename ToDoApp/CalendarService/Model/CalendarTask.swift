//
//  CalendarTask.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 6/1/26.
//

import Foundation

final class CalendarTask: Identifiable{
    var id: UUID
    var date: Date
    var title: String
    
    init(
        id: UUID = UUID(),
        date: Date = Date(),
        title: String = ""
    ) {
        self.id = id
        self.date = date
        self.title = title
    }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}()

let calendarTasks: [CalendarTask] = [
    CalendarTask(date: dateFormatter.date(from: "2026-06-01")!, title: "Team Meating"),
    CalendarTask(date: dateFormatter.date(from: "2026-06-02")!, title: "Team Meating"),
    CalendarTask(date: dateFormatter.date(from: "2026-06-03")!, title: "Team Meating"),
    CalendarTask(date: dateFormatter.date(from: "2026-06-04")!, title: "Team Meating"),
    CalendarTask(date: dateFormatter.date(from: "2026-06-05")!, title: "Team Meating"),
    CalendarTask(date: dateFormatter.date(from: "2026-06-05")!, title: "Team Meating")
]


