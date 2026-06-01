//
//  CalendarTaskListView.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 5/30/26.
//


import SwiftUI

struct CalendarTaskListView: View {
    
    
    let calendarTasks: [CalendarTask]
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 8) {
                
                if calendarTasks.isEmpty {
                    VStack{
                        Text("No tasks for this day.")
                        Text("Tap here to add task")
                    }
                        .font(.title2)
                        .frame(height: 55)
                        .foregroundStyle(.gray)
                } else {
                    
                    ForEach(calendarTasks.indices, id: \.self) { index in
                        let task = calendarTasks[index]
                        
                        HStack{
                            Text("\(index + 1).")
                            
                            Text(task.title)
                            
                            Spacer()
                            
                            Image(systemName: "circle")
                            
                        }
                        .frame(height: 55)
                        .padding(.horizontal, 12)
                        .background(.BG, in: .rect(cornerRadius: 16))
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}


#Preview {
    CalendarTaskListView(calendarTasks: calendarTasks)
}
