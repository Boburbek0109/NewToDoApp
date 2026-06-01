//
//  CalendarHeaderView.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 6/1/26.
//

import SwiftUI

struct CalendarHeaderView: View {
    
    @Binding var currentDate: Date
    @Binding var selectedDate: Date?
    
    let manager = CalendarManager()
    
    var body: some View {
        
        HStack{
            Button(action: {
                currentDate = manager.previousMonth(from: currentDate)
                selectedDate = nil
            }) { Image(systemName: "chevron.left") }
            
            Spacer()
            
            Text(manager.monthYearString(from: currentDate))
                .font(.title2)
                .padding(.bottom, 10)
            
            Spacer()
            
            Button(action: {
                currentDate = manager.nextMonth(from: currentDate)
                selectedDate = nil
            }) { Image(systemName: "chevron.right") }
        }
        .tint(.primary)
        .padding(.horizontal)
        
        HStack(spacing: 2){
            ForEach(manager.weekdays(), id: \.self) { day in
                Text(day)
                    .font(.system(size: 15))
                    .frame(maxWidth: .infinity)
                
                    .foregroundStyle(day == manager.todayWeeknd() ? Color.primary : Color.gray)
                    .padding(.vertical, 3)
                
                    .background(day == manager.todayWeeknd() ? .gray.opacity(0.4) : .gray.opacity(0.2),
                                in: .rect(cornerRadius: 8))
            }
        }
    }
}
