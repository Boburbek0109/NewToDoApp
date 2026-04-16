//
//  ContentView.swift
//  ToDoApp
//
//  Created by Bobur Sobirjanov on 4/8/26.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var vm = TaskViewModel()
    
    let manager = Calendar​Service.instans
    
    @State private var calendarStats = CalendarStats.empty
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let columns1 = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            ScrollView {
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
                
                ZStack {
                    RoundedRectangle(cornerSize: CGSize(width: 30, height: 30))
                        .frame(width: 360, height: 180)
                        .foregroundStyle(.gray.opacity(0.4))
                    
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        if vm.favoriteTasks.isEmpty{
                            Text("Favorites")
                                .font(.callout)
                                .opacity(0.55)
                        } else {
                            ForEach(vm.favoriteTasks) { task in
                                Label(task.name, systemImage: "star.fill")
                            }
                        }
                    }
                    .padding(.horizontal)
                    .font(.title3)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                }
                
                
                LazyVGrid(columns: columns, spacing: 10) {
                    NavigationLink{
                        QuickNote(vm: vm)
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 30)
                                .frame(width: 180, height: 180)
                                .foregroundStyle(.gray.opacity(0.4))
                            Label("Quick Note", systemImage: "pencil")
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .truncationMode(.tail)
                                .foregroundStyle(.black)
                                .font(.title3)
                        }
                    }
                    
                    NavigationLink{
                        DailyTasks(vm: vm)
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 30)
                                .frame(width: 180, height: 180)
                                .foregroundStyle(.gray.opacity(0.4))
                            
                            Label("Daily Tasks", systemImage: "calendar")
                                .foregroundStyle(.black)
                                .font(.title3)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .ignoresSafeArea(edges: .all)
        .task {
            calendarStats = await manager.stats()
        }
        .onAppear(perform: vm.loadItems)
        .onChange(of: vm.tasks) {
            vm.saveItems()
        }
    }
}
    

#Preview {
    ContentView()
}



