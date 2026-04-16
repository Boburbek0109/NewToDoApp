//
//  ContentView.swift
//  ToDoApp
//
//  Created by Bobur Sobirjanov on 4/8/26.
//

import SwiftUI

struct ContentView: View {
    
    let manager = CalendarViewModel.instans
    
    @State private var calendarStats = CalendarStats.empty
    
    @State private var tasks: [NewToDoTask] = []
    private let storageKey = "items_list"
    
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
                        .overlay(alignment: .bottomTrailing) {
                            AddButton()
                                .padding(.bottom, 12)
                        }

                    VStack(alignment: .leading, spacing: 8) {
                        Spacer()

                        Text("Favorites")
                            .font(.callout)
                            .opacity(0.55)

                        Label("Second Brain", systemImage: "brain")
                        Label("Content Calendar", systemImage: "calendar")
                        Label("Decisions", systemImage: "arrowtriangle.up.circle.fill")

                        Spacer()
                    }
                    .padding(.horizontal)
                    .font(.title3)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                }

                LazyVGrid(columns: columns, spacing: 10) {
                    NavigationLink{
                        QuickNote(tasks: $tasks)
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
                        DailyTasks(tasks: $tasks)
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
        .onAppear(perform: loadItems)
        .onChange(of: tasks) {
            saveItems()
        }
    }

    private func saveItems() {
        guard let encodedData = try? JSONEncoder().encode(tasks) else { return }
        UserDefaults.standard.set(encodedData, forKey: storageKey)
    }

    private func loadItems() {
        guard
            let data = UserDefaults.standard.data(forKey: storageKey),
            let savedItems = try? JSONDecoder().decode([NewToDoTask].self, from: data)
        else { return }

        tasks = savedItems
    }
}

#Preview {
    ContentView()
}
