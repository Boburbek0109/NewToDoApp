//
//  СalendarService​.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 4/10/26.
//

import Foundation

struct CalendarStats {
    let currentDay: Int
    let daysInCurrentMonth: Int
    let percent: Double

    static let empty = CalendarStats(currentDay: 1, daysInCurrentMonth: 30, percent: 0)
}

actor СalendarService {
    static let instans = СalendarService()

    private let calendar = Calendar.current

    private var currentDay: Int { calendar.component(.day, from: Date()) }

    private var daysInCurrentMonth: Int {
        calendar.range(of: .day, in: .month, for: Date())?.count ?? 30
    }

    private var passedDays: Int { currentDay }

    private var totalDays: Int { daysInCurrentMonth }

    private var percent: Double { Double(passedDays) / Double(totalDays) * 100 }

    func stats() -> CalendarStats {
        CalendarStats(
            currentDay: currentDay,
            daysInCurrentMonth: daysInCurrentMonth,
            percent: percent
        )
    }
}
