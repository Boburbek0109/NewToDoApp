//
//  CalendarService​.swift
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

actor CalendarService {
    static let instance = CalendarService()
    private let calendar: Calendar

    init(calendar: Calendar = Calendar.current) {
        self.calendar = calendar
    }
    
    func stats(referenceDate: Date) -> CalendarStats {
        let currentDay = calendar.component(.day, from: referenceDate)
        let daysInCurrentMonth = calendar.range(of: .day, in: .month, for: referenceDate)?.count ?? 30
        let percent = Double(currentDay) / Double(daysInCurrentMonth) * 100
        
        return CalendarStats(
            currentDay: currentDay,
            daysInCurrentMonth: daysInCurrentMonth,
            percent: percent
        )
    }
    
    func nextMidnight(referenceDate: Date) -> Date? {
        calendar.dateInterval(of: .day, for: referenceDate)?.end
    }
}

var formattedDate: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM d"
    return formatter.string(from: Date())
}

extension DateFormatter {
    static let dateFormatted: DateFormatter = {
        let time = DateFormatter()
        time.dateStyle = .short
        time.timeStyle = .short
        return time
    }()
}
