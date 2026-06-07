//
//  CalendarPlanEditorView.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 6/2/26.
//

import SwiftUI

struct CalendarPlanEditorView: View{
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var titlePlan: String
    @State private var contentPlan: String
    @State private var startDate:  Date
    @State private var endDate: Date
    
    private let plan: CalendarPlan?
    let onSave: (CalendarPlan?, String, String, Date, Date) -> Void
    
    init(
        plan: CalendarPlan? = nil,
        onSave: @escaping (CalendarPlan?, String, String, Date, Date) -> Void
    ) {
        self.plan = plan
        self.onSave = onSave
        
        _titlePlan = State(initialValue: plan?.title ?? "")
        _contentPlan = State(initialValue: plan?.details ?? "")
        _startDate = State(initialValue: plan?.startDate ?? Date())
        _endDate = State(initialValue: plan?.endDate ?? Date().addingTimeInterval(3600))
    }
    
    private var minimumDate: Date {
        if let plan{
            return min (
                Calendar.current.startOfDay(for: Date()),
                Calendar.current.startOfDay(for: plan.startDate)
            )
        }
        
        return Calendar.current.startOfDay(for: Date())
    }
    
    var body: some View{
        
        NavigationStack{
            Form{
                Section("Plans for Event"){
                    
                    TextField("Title", text: $titlePlan)
                    
                    DatePicker(
                        "Start",
                        selection: $startDate,
                        in: minimumDate...,
                        displayedComponents: [.date, .hourAndMinute])
                    
                    DatePicker(
                        "End",
                        selection: $endDate,
                        in: startDate...,
                        displayedComponents: [.date, .hourAndMinute])
                    
                }
                
                Section("Notes") {
                    TextField("Add notes (optional)", text: $contentPlan, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle(plan == nil ? "New Plan" : "Edit Plan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save"){
                        let trimmedPlan = titlePlan.trimmingCharacters(in: .whitespacesAndNewlines)
                        let trimmedContent = contentPlan.trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        onSave(plan, trimmedPlan, trimmedContent, startDate, endDate)
                        dismiss()
                        
                    }
                    .disabled(
                        titlePlan.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                        contentPlan.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    )
                }
            }
        }
    }
}
