//
//  CalendarPlanListView.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 5/30/26.
//


import SwiftUI

struct CalendarPlanListView: View {
    
    let plans: [CalendarPlan]
    let onEdit: (CalendarPlan) -> Void
    let onDelete: (CalendarPlan) -> Void
    
    var body: some View {
        List{
            
            if plans.isEmpty {
                VStack(alignment: .leading){
                    Text("No tasks for this day.")
                    Text("Tap to + for add your plans")
                }
                .font(.title2)
                .frame(height: 55)
                .foregroundStyle(.gray)
            } else {
                
                ForEach(Array(plans.enumerated()), id: \.element.id) { index, task in
                    
                    HStack{
                        Text("\(index + 1).")
                        
                        VStack(alignment: .leading, spacing: 3){
                            Text(task.title)
                            
                            if !task.details.isEmpty{
                                Text(task.details)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Spacer()
                    }
                    .frame(height: 55)
                    .padding(.horizontal, 12)
                    .background(.BG, in: .rect(cornerRadius: 16))
                    .swipeActions {
                        Button(role: .destructive){
                            onDelete(task)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        onEdit(task)
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}

        
