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
    @Published private(set) var loadErrorMessages: String?
    
    private var calendarContext: ModelContext
//    private var simulateLoadFailure = true
    
    init(calendarContext: ModelContext) {
        self.calendarContext = calendarContext
        loadPlans()
    }
    
    func loadPlans() {
        let descriptor = FetchDescriptor<CalendarPlan>(
            sortBy: [SortDescriptor(\.startDate)])
        do {
            plans = try calendarContext.fetch(descriptor)
            loadErrorMessages = nil
        } catch {
            loadErrorMessages = error.localizedDescription
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
        
        let saveContext = ModelContext(calendarContext.container)
        saveContext.autosaveEnabled = false
        
        let plan = CalendarPlan(
            title: trimmedTitle,
            details: trimmedDetails,
            startDate: startDate,
            endDate: endDate)
        
        saveContext.insert(plan)
        try saveContext.save()
        loadPlans()
    }
    
    func deletePlan(_ plansToDelete: [CalendarPlan]) throws {
        let deleteContext = ModelContext(calendarContext.container)
        deleteContext.autosaveEnabled = false
        
        for plan in plansToDelete {
            let deleteID = plan.id
            let predicte = #Predicate<CalendarPlan> { delet in
                delet.id == deleteID}
            let description = FetchDescriptor<CalendarPlan>(predicate: predicte)
            let deleteMatching = try deleteContext.fetch(description)
            guard let deletedPlan = deleteMatching.first else { throw NSError(domain: "CalendarPlan.Delete", code: 1, userInfo: [NSLocalizedDescriptionKey: "This event could not be found."]) }
            deleteContext.delete(deletedPlan)
        }
        try deleteContext.save()
        loadPlans()
    }
    
    func updatePlan (_ plan: CalendarPlan, title: String, details: String, startDate: Date,endDate: Date) throws {
        
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDetails = details.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty else {
            throw CalendarPlanValidationError.emptyTitle
        }
        guard endDate >= startDate else {
            throw CalendarPlanValidationError.invalidDateRange
        }
        let updateContext = ModelContext(calendarContext.container)
        updateContext.autosaveEnabled = false
        let planID = plan.id
        let predicte = #Predicate<CalendarPlan> { afs in
            afs.id == planID }
        let description = FetchDescriptor<CalendarPlan>(predicate: predicte)
        let matchingPlan = try updateContext.fetch(description)
        guard let savedPlan = matchingPlan.first else { throw NSError(domain: "CalendarPlan.Update", code: 1, userInfo: [NSLocalizedDescriptionKey: "This event could not be found."]) }
        
        savedPlan.title = trimmedTitle
        savedPlan.details = trimmedDetails
        savedPlan.startDate = startDate
        savedPlan.endDate = endDate
        
        try updateContext.save()
        plan.title = savedPlan.title
        plan.details = savedPlan.details
        plan.startDate = savedPlan.startDate
        plan.endDate = savedPlan.endDate
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
