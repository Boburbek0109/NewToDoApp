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
        
        do {
            plans = try calendarContext.fetch(descriptor)
        } catch {
            print("Failed to load calendar plans: \(error)")
        }
    }
    
    func addPlan(
        title: String,
        details: String,
        startDate: Date,
        endDate: Date
    ) throws {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDetails = details.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty else {
            throw CalendarPlanValidationError.emptyTitle
        }
        guard endDate >= startDate else {
            throw CalendarPlanValidationError.invalidDateRange
        }
        
        let plan = CalendarPlan(
            title: trimmedTitle,
            details: trimmedDetails,
            startDate: startDate,
            endDate: endDate
        )
        
        
        calendarContext.insert(plan)
        try calendarContext.save()
        loadPlans()
    }
    
    func deletePlan(_ plansToDelete: [CalendarPlan]) throws{
        for plan in plansToDelete {
            calendarContext.delete(plan)
        }
        try calendarContext.save()
        loadPlans()
    }
    
    func updatePlan(
        _ plan: CalendarPlan,
        title: String,
        details: String,
        startDate: Date,
        endDate: Date
    ) throws {
        
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDetails = details.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty else {
            throw CalendarPlanValidationError.emptyTitle
        }
        guard endDate >= startDate else {
            throw CalendarPlanValidationError.invalidDateRange
        }
        
        plan.title = trimmedTitle
        plan.details = trimmedDetails
        plan.startDate = startDate
        plan.endDate = endDate
        
        try calendarContext.save()
        loadPlans()
    }
}

enum CalendarPlanValidationError: LocalizedError {
    case emptyTitle
    case invalidDateRange
    
    var errorDescription: String? {
        switch self {
        case .emptyTitle:
            return "Please enter a title"
        case .invalidDateRange:
            return "Start date must be before end date"
        }
    }
}
