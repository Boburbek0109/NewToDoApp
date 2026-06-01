//
//  CustomCalendarView.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 5/30/26.
//

import SwiftUI

struct CustomCalendarView: View {
    
    @State private var isCurrent = Date()
    @State private var isSelectedDate: Date? = Date()
    
    let manager = CalendarManager()
    
    var body: some View {
        
        VStack(spacing: 24){
            
            CalendarHeaderView(currentDate: $isCurrent, selectedDate: $isSelectedDate)
            
            let days = manager.generateMonthGrid(for: isCurrent)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                
                ForEach(days, id: \.self){ day in
                    
                    let isCurrentMonth = manager.isSameMonth(day, isCurrent)
                    let tasksForDay = calendarTasks.filter{ manager.isSameDay($0.date, day) }
                    let isSelected = isSelectedDate != nil && manager.isSameDay(isSelectedDate!, day)
                    
                    
                    VStack(spacing: 4){
                        Text("\(manager.dayNumber(from: day))")
                            .font(.system(size: 15))
                            .frame(maxWidth: .infinity, minHeight: 45)
                        
                            .foregroundColor(isSelected ? .se : (isCurrentMonth ? .primary : .gray))
                            .background(isSelected ? Color.primary : isCurrentMonth ? .BG : .gray.opacity(0.2))
                            .clipShape(Circle())
                        
                            .overlay {
                                Circle()
                                    .stroke(lineWidth: 1)
                                    .foregroundStyle(manager.isToday(day) ? Color.primary : .clear)
                                    .padding(1)
                            }
                            .overlay(alignment: .bottom) {
                                HStack(spacing: 3){
                                    ForEach(0..<min(tasksForDay.count, 5), id: \.self) { _ in
                                        Circle()
                                            .frame(width: 4, height: 4).padding(.bottom, 6)
                                            .foregroundStyle(isSelected ? .se : .primary)
                                        
                                    }
                                }
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
                                 
            let visibleTasks = isSelectedDate != nil
            ? calendarTasks.filter { manager.isSameDay($0.date, isSelectedDate!) }
            : []

            CalendarTaskListView(calendarTasks: visibleTasks)
        }
        .padding()
        
        Spacer()
    }
}


#Preview {
    CustomCalendarView()
}
