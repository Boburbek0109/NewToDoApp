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
    @State private var saveErrorMessage: String?
    
    private let plan: CalendarPlan?
    let onSave: (CalendarPlan?, String, String, Date, Date) throws -> Void
    
    init(
        plan: CalendarPlan? = nil,
        initialDay: Date,
        calendar: Calendar,
        onSave: @escaping (CalendarPlan?, String, String, Date, Date) throws -> Void
    ) {
        self.plan = plan
        self.onSave = onSave
        
        _titlePlan = State(initialValue: plan?.title ?? "")
        _contentPlan = State(initialValue: plan?.details ?? "")
        let defaultStart = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: initialDay)
        _startDate = State(initialValue: plan?.startDate ?? defaultStart ?? initialDay)
        _endDate = State(initialValue: plan?.endDate ?? (defaultStart ?? initialDay).addingTimeInterval(3600))
    }
    
    var body: some View{
        
        NavigationStack{
            Form{
                Section("Plans for Event"){
                    
                    TextField("Title", text: $titlePlan)
                    
                    DatePicker(
                        "Start",
                        selection: $startDate,
                        displayedComponents: [.date, .hourAndMinute])
                    .onChange(of: startDate) {
                        if startDate > endDate {
                            endDate = startDate.addingTimeInterval(3600)
                        }
                    }
                    
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
                if let message = saveErrorMessage {
                    Text(message)
                        .foregroundStyle(.red)
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
                        do{
                            try onSave(plan, trimmedPlan, trimmedContent, startDate, endDate)
                        } catch {
                            saveErrorMessage = error.localizedDescription
                        }
                    }
                    .disabled(titlePlan.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
