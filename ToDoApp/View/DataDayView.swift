//
//  DataDayView.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 4/22/26.
//

import SwiftUI

struct DataDayView: View {
    
    let manager = СalendarService.instans
    @State private var calendarStats = CalendarStats.empty
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let columns1 = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .frame(width: 180, height: 180)
                    .foregroundStyle(.gray.opacity(0.4))
                
                VStack {
                    HStack {
                        Text("\(Date().formatted(.dateTime.weekday()))")
                            .font(.title3)
                            .bold()
                        
                        Text("\(Date().formatted(.dateTime.month()))")
                            .font(.title2)
                            .opacity(0.55)
                    }
                    
                    Text("\(Date().formatted(.dateTime.day()))")
                        .font(.system(size: 100, weight: .bold))
                }
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .frame(width: 180, height: 180)
                    .foregroundStyle(.gray.opacity(0.4))
                
                VStack {
                    HStack(spacing: 65) {
                        Text("Days")
                            .font(.title2)
                            .bold()
                        
                        Text("\(Int(calendarStats.percent))%")
                            .font(.title2)
                            .opacity(0.55)
                    }
                    
                    LazyVGrid(columns: columns1) {
                        ForEach(1...calendarStats.daysInCurrentMonth, id: \.self) { day in
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundStyle(day <= calendarStats.currentDay ? .black : .gray)
                        }
                    }
                }
            }
        }
        .task {
            calendarStats = await manager.stats()
        }
        
        
    }
}


#Preview {
    DataDayView()
}
