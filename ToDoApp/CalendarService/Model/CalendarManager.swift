//
//  CalendarManager.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 5/30/26.
//

import Foundation

struct CalendarManager {
    
    let calendar = Calendar.current
    
    func todayWeekdayIndex() -> Int {
        let originalIndex = calendar.component(.weekday, from: Date()) - 1
        return (originalIndex + 6) % 7
    }
    
    func  weekdays() -> [String] {
        let symbol = calendar.shortStandaloneWeekdaySymbols
        return Array(symbol[1...6] + [symbol[0]])
    }
    
    func todayWeeknd() -> String {
        weekdays()[todayWeekdayIndex()]
    }
    
    func generateMonthGrid(for date: Date) -> [Date]{
        guard let monthInterval = calendar.dateInterval(of: .month, for: date),
              let firstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let lastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end - 1)
                
        else { return [] }
        return stride(from: firstWeek.start, to: lastWeek.end, by: 86400).map {$0}
    }
    
    func nextMonth(from date: Date) -> Date {
        
        calendar.date(byAdding: .month, value: 1, to: date) ?? date
    }
    
    func previousMonth(from date: Date) -> Date {
        
        calendar.date(byAdding: .month, value: -1, to: date) ?? date
    }
    
    func isSameDay(_ firstDate: Date, _ secondDate: Date) -> Bool{
        calendar.isDate(firstDate, inSameDayAs: secondDate)
    }
    
    func isSameMonth(_ firstDate: Date, _ secondDate: Date) -> Bool{
        calendar.isDate(firstDate, equalTo: secondDate, toGranularity: .month)
    }
    
    func dayNumber(from date: Date) -> Int {
        calendar.component(.day, from: date)
    }
    
    func isToday(_ date: Date) -> Bool{
        calendar.isDateInToday(date)
    }
    
    private var monthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    func monthYearString(from date: Date) -> String {
        monthYearFormatter.string(from: date)
    }
    
    func isDay(_ day: Date, inside plan: CalendarPlan) -> Bool {
        let day = calendar.startOfDay(for: day)
        let startDate = calendar.startOfDay(for: plan.startDate)
        let endDate = calendar.startOfDay(for: plan.endDate)
        
        return day >= startDate && day <= endDate
    }
}
