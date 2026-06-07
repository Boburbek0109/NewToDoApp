//
//  CalendarPlanViewModel.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 6/5/26.
//

import Foundation
import SwiftData
import Combine

@MainActor
final class CalendarPlanViewModel: ObservableObject {
    
    @Published private(set) var plans: [CalendarPlan] = []
    
    private var calendarContext: ModelContext
    
    init(calendarContext: ModelContext) {
        self.calendarContext = calendarContext
        loadPlans()
    }
    
    func loadPlans() {
        let descriptor = FetchDescriptor<CalendarPlan>(
            sortBy: [SortDescriptor(\.startDate)]
        )
        plans = (try? calendarContext.fetch(descriptor)) ?? []
    }
    
    func addPlan(
        title: String,
        details: String,
        startDate: Date,
        endDate: Date
    ) throws {
        let event = CalendarPlan(
            title: title,
            details: details,
            startDate: startDate,
            endDate: endDate
        )
        calendarContext.insert(event)
        try calendarContext.save()
        loadPlans()
    }
    
    func deletePlan(_ eventToDelete: [CalendarPlan]) throws{
        for event in eventToDelete {
            calendarContext.delete(event)
        }
        try calendarContext.save()
        loadPlans()
    }
    
    func updatePlan(
        _ event: CalendarPlan,
        title: String,
        details: String,
        startDate: Date,
        endDate: Date
    ) throws {
        event.title = title
        event.details = details
        event.startDate = startDate
        event.endDate = endDate
        
        try calendarContext.save()
        loadPlans()
    }
}
