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
        Group{
            if plans.isEmpty {
                ContentUnavailableView(
                    "No plans for this day.",
                    systemImage: "calendar",
                    description: Text("Tap + to add a plan"))
            } else {
                ForEach(Array(plans.enumerated()), id: \.element.id) { index, task in
                    HStack{
                        Text("\(index + 1) ")
                        
                        VStack(alignment: .leading, spacing: 3){
                            Text(task.title)
                                .font(.title3)
                                .foregroundStyle(.primary)
                            
                            if !task.details.isEmpty{
                                Text(task.details)
                                    .lineLimit(3)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Text(task.startDate.formatted(.dateTime.month(.abbreviated).day().hour().minute()))
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(minHeight: 55)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.BG, in: .rect(cornerRadius: 16))
                    .listRowInsets(.vertical, 0)
                    .swipeActions {
                        Button(role: .destructive) {
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
    }
}
