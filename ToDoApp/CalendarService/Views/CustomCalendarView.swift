//
//  CustomCalendarView.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 5/30/26.
//

import SwiftUI
import SwiftData

private enum PlanEditorMode: Identifiable{
    case create
    case edit(CalendarPlan)
    
    var id: String{
        switch self{
        case .create:
            return "create"
        case .edit(let plan):
            return plan.id.uuidString
        }
    }
    
    var plan: CalendarPlan?{
        switch self{
        case .create:
            return nil
        case .edit(let plan):
            return plan
        }
    }
}

struct CustomCalendarView: View {
    @EnvironmentObject var calendarVM: CalendarPlanViewModel
    
    @State private var isCurrent: Date
    @State private var isSelectedDate: Date?
    @State private var editMode: PlanEditorMode?
    @State private var deleteErrorMessage = ""
    @State private var showDeleteError = false
    
    let manager = CalendarManager()
    
    init( initialDay: Date = Date() ) {
        _isCurrent = State(initialValue: initialDay)
        _isSelectedDate = State(initialValue: initialDay)
    }
    
    var body: some View {
        List{
            VStack(spacing: 24) {
                CalendarHeaderView(currentDate: $isCurrent, selectedDate: $isSelectedDate, manager: manager)
                
                let days = manager.generateMonthGrid(for: isCurrent)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                    
                    ForEach(days, id: \.self){ day in
                        
                        let isCurrentMonth = manager.isSameMonth(day, isCurrent)
                        let plansForDay = calendarVM.plans.filter { manager.isDay(day, inside: $0) }
                        let isSelected = isSelectedDate != nil && manager.isSameDay(isSelectedDate!, day)
                        
                        
                        VStack(spacing: 4){
                            Text("\(manager.dayNumber(from: day))")
                                .font(.system(size: 15))
                                .frame(maxWidth: .infinity, minHeight: 45)
                                .foregroundColor(isSelected ? .se : (isCurrentMonth ? .primary : .gray))
                                .background(isSelected ? Color.primary : isCurrentMonth ? .BG : .gray.opacity(0.2))
                                .clipShape(Circle())
                                .overlay{
                                    Circle()
                                        .stroke(lineWidth: 1)
                                        .foregroundStyle(manager.isToday(day) ? Color.primary : .clear)
                                        .padding(1)
                                }
                            
                            if !plansForDay.isEmpty{
                                Capsule()
                                    .fill(.blue)
                                    .frame(width: 28, height: 6)
                            } else {
                                Color.clear
                                    .frame(width: 28, height: 6)
                            }
                        }
                        .onTapGesture {
                            if let selected = isSelectedDate, manager.isSameDay(selected, day) {
                                isSelectedDate = nil
                            } else {
                                isSelectedDate = day
                            }
                        }
                    }
                }
            }
            let visiblePlans = isSelectedDate.map { selectedDate in
                calendarVM.plans.filter { manager.isDay(selectedDate, inside: $0) }
            } ?? []
            
            if let message = calendarVM.loadErrorMessages {
                VStack(spacing: 12) {
                    Text(message)
                    
                    Button("Retry") { calendarVM.loadPlans() }
                }
            }
            CalendarPlanListView( plans: visiblePlans, onEdit: { plan in
                editMode = .edit(plan)}, onDelete: { plan in
                    do {
                        try calendarVM.deletePlan([plan])
                    } catch {
                        deleteErrorMessage = error.localizedDescription
                        showDeleteError = true
                    }
                })
        }
        .listStyle(.plain)
        .navigationTitle("Calendar")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Couldn’t delete event", isPresented: $showDeleteError){
            Button("OK") { }
        } message: { Text(deleteErrorMessage) }
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                Button{
                    editMode = .create
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(item: $editMode) { mode in
            CalendarPlanEditorView(plan: mode.plan, initialDay: isSelectedDate ?? Date(), calendar: manager.calendar) { plan, titlePlan, contentPlan, startDate, endDate in
                if let plan {
                    try calendarVM.updatePlan(
                        plan,
                        title: titlePlan,
                        details: contentPlan,
                        startDate: startDate,
                        endDate: endDate)
                } else {
                    try calendarVM.addPlan(
                        title: titlePlan,
                        details: contentPlan,
                        startDate: startDate,
                        endDate: endDate)
                }
                editMode = nil
            }
            .environment(\.calendar, manager.calendar)
            .environment(\.timeZone, manager.calendar.timeZone)
        }
        .padding()
    }
}


#Preview {
    let container = try! ModelContainer(
        for: CalendarPlan.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let calendarVM = CalendarPlanViewModel(calendarContext: container.mainContext)
    
    NavigationStack{
        CustomCalendarView()
    }
    .modelContainer(container)
    .environmentObject(calendarVM)
}
