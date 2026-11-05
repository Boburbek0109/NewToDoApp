//
//  DataDayView.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 4/22/26.
//

import SwiftUI

struct DataDayView: View {
    @Environment(\.scenePhase) private var scenePhase
    let manager = CalendarService.instance
    @State private var calendarStats = CalendarStats.empty
    @State private var referenceDate = Date()
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        LazyVGrid(columns: columns) {
            NavigationLink{
                CustomCalendarView()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .frame(maxWidth: .infinity)
                        .frame(height: 180)
                        .foregroundStyle(Color(uiColor: .secondarySystemGroupedBackground))
                    
                    VStack {
                        HStack {
                            Text("\(referenceDate.formatted(.dateTime.weekday()))")
                                .font(.title3)
                                .bold()
                            
                            Text("\(referenceDate.formatted(.dateTime.month()))")
                                .font(.title2)
                                .opacity(0.55)
                        }
                        
                        Text("\(referenceDate.formatted(.dateTime.day()))")
                            .font(.system(size: 100, weight: .bold))
                    }
                }
                .foregroundStyle(.primary)
            }
            .buttonStyle(.plain)
            
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .frame(maxWidth: .infinity)
                    .frame(height: 180)
                    .foregroundStyle(Color(uiColor: .secondarySystemGroupedBackground))
                
                VStack {
                    HStack {
                        Text("This Month")
                            .font(.headline)
                            .bold()
                        
                        Spacer()
                        
                        Text("\(Int(calendarStats.percent))%")
                            .font(.headline)
                            .opacity(0.55)
                    }
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6)) {
                        ForEach(1...calendarStats.daysInCurrentMonth, id: \.self) { day in
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundStyle(day <= calendarStats.currentDay ? Color.primary : Color.secondary)
                        }
                    }
                }
                .padding(16)
            }
        }
        .task(id: scenePhase) {
            guard scenePhase == .active else { return }
            while !Task.isCancelled {
                referenceDate = Date()
                calendarStats = await manager.stats(referenceDate: referenceDate)
                guard let nextMidnight = await manager.nextMidnight(referenceDate: referenceDate) else { return }
                let secondsUntilMidnight = nextMidnight.timeIntervalSince(Date())
                do{ try await Task.sleep(for: .seconds(secondsUntilMidnight))
                } catch { return }
            }
        }
    }
}


#Preview {
    DataDayView()
}
