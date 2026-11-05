//
//  ToDoTests.swift
//  ToDoTests
//
//  Created by Bobur Sobirjanov on 11/5/26.
//

import Testing
import Foundation
import SwiftData
@testable import ToDo

@MainActor
struct ToDoTests {

    @Test func nextMidnightMovesToNextYear() async throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .gmt
        let service = CalendarService(calendar: calendar)
        let inputComponents = DateComponents(year: 2026, month: 12, day: 31, hour: 23, minute: 50, second: 0)
        let expectedComponents = DateComponents(year: 2027, month: 1, day: 1, hour: 0, minute: 0, second: 0)
        let inputDate = try #require(calendar.date(from: inputComponents))
        let expectedDate = try #require(calendar.date(from: expectedComponents))
        let actualData = await service.nextMidnight(referenceDate: inputDate)
        
        #expect(actualData == expectedDate)
    }
    
    @Test func emptyTaskIsNotAdded() async throws {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ModelTask.self, configurations: configuration)
        let viewModel = TaskViewModel(context: container.mainContext)
        
        try viewModel.addTask(from: "  ")
        #expect(viewModel.tasks.isEmpty)
    }
    
    @Test func addingTaskPersistsIt() async throws {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ModelTask.self, configurations: configuration)
        let viewModel = TaskViewModel(context: container.mainContext)
        try viewModel.addTask(from: "Read Swift")
        
        let verificationContext = ModelContext(container)
        let descriptor = FetchDescriptor<ModelTask>()
        let savedTasks = try verificationContext.fetch(descriptor)
        
        #expect(savedTasks.count == 1)
        #expect(savedTasks.first?.title == "Read Swift")
    }
    
    @Test func searchMatchesTitleAndContent() async throws {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ModelNote.self, NoteCategory.self, configurations: configuration)
        let viewModel = NoteViewModel(noteContext: container.mainContext)
        
        try viewModel.addNote(title: "Swift Basics", content: "Learing language")
        try viewModel.addNote(title: "Practice", content: "Write SWIFT every day")
        try viewModel.addNote(title: "Shopping", content: "Buy milk")

        let results = viewModel.filteredNote(for: nil, searchText: " sWift ")
        #expect(results.count == 2)
        #expect(results.contains { note in
            note.title == "Swift Basics"})
        #expect(results.contains { note in
            note.title == "Practice"})
    }
    
    @Test func assigningSameColorReusesCategory() async throws {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ModelNote.self, NoteCategory.self, configurations: configuration)
        let viewModel = NoteViewModel(noteContext: container.mainContext)
        let firstNote = ModelNote(title: "First", content: "First note")
        let secondNote = ModelNote(title: "Second", content: "Second note")
        container.mainContext.insert(firstNote)
        container.mainContext.insert(secondNote)
        try container.mainContext.save()
        try viewModel.assignColor("blue", to: firstNote)
        try viewModel.assignColor("blue", to: secondNote)
        
        #expect(viewModel.categories.count == 1)
        let firstCategory = try #require(firstNote.category)
        let secondCategory = try #require(secondNote.category)
        #expect(firstCategory.id == secondCategory.id)
    }
    
    @Test func eventWithEndBeforeStartIsRejected() async throws {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: CalendarPlan.self, configurations: configuration)
        let viewModel = CalendarPlanViewModel(calendarContext: container.mainContext)
        let startDate = Date()
        let endDate = startDate.addingTimeInterval(-3600)
        
        #expect(throws: CalendarPlanValidationError.invalidDateRange) {
            try viewModel.addPlan(title: "Meeting", details: "", startDate: startDate, endDate: endDate)
        }
        
        let verificationContext = ModelContext(container)
        let descriptor = FetchDescriptor<CalendarPlan>()
        let savedPlans = try verificationContext.fetch(descriptor)
        
        #expect(savedPlans.isEmpty)
    }
    
    @Test func failedBatchDeletionKeepsExistingTask() async throws {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ModelTask.self, configurations: configuration)
        let viewModel = TaskViewModel(context: container.mainContext)
        let existingTask = ModelTask(title: "Keep me")
        let missingTask = ModelTask(title: "Missing")
        
        container.mainContext.insert(existingTask)
        try container.mainContext.save()
        #expect(throws: TaskOperationError.taskNotFound) {
            try viewModel.deleteTasks([existingTask, missingTask])
        }
        
        let verificationContext = ModelContext(container)
        let descriptor = FetchDescriptor<ModelTask>()
        let savedTasks = try verificationContext.fetch(descriptor)
        
        #expect(savedTasks.count == 1)
        #expect(savedTasks.first?.id == existingTask.id)
    }
    
    @Test func savedTaskSurvivesContainerReopen() async throws {
        let fileManager = FileManager.default
        let testDirectory = fileManager.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        
        try fileManager.createDirectory(at: testDirectory, withIntermediateDirectories: true)
        defer { try? fileManager.removeItem(at: testDirectory) }
        let storeURL = testDirectory.appendingPathComponent("Test.store")
        let configuration = ModelConfiguration(url: storeURL)
        let expectedID = UUID()
        do {
            let container = try ModelContainer(for: ModelTask.self, configurations: configuration)
            let context = ModelContext(container)
            context.autosaveEnabled = false
            let task = ModelTask(id: expectedID, title: "Saved Task")
            context.insert(task)
            try context.save() }
        
        do {
            let reopenedContainer = try ModelContainer(for: ModelTask.self, configurations: configuration)
            let verificationContext = ModelContext(reopenedContainer)
            let descriptor = FetchDescriptor<ModelTask>()
            let savedTasks = try verificationContext.fetch(descriptor)
            
            #expect(savedTasks.count == 1)
            #expect(savedTasks.first?.id == expectedID)
            #expect(savedTasks.first?.title == "Saved Task")
        }
    
    }
}
