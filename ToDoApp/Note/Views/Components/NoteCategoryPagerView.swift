//
//  NoteCategoryPagerView.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 5/27/26.
//

import SwiftUI

enum NoteTab: Hashable{
    case all
    case category(UUID)
}

struct NoteCategoryPagerView: View {
    @EnvironmentObject var noteVM: NoteViewModel
    
    @State private var selectedTab: NoteTab? = .all
    @State private var editingCategory: NoteCategory?
    @State private var editingName = ""
    @State private var showRenameAlert = false
    @State private var showRenameError = false
     
    let searchText: String
    
    private var noteTabs: [NoteCategory?] {
        [nil] + noteVM.usedCategories
    }
    
    private func tabID(for category: NoteCategory?) -> NoteTab {
        if let category { return .category(category.id) }
        return .all
    }
    
    var body: some View {
            VStack(spacing: 15){
                if !noteVM.notes.isEmpty { noteTabView }
                
                GeometryReader{ _ in
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 0){
                            ForEach(Array(noteTabs.enumerated()), id: \.element?.id){ _, category in
                                NotePageView(searchText: searchText, category: category)
                                    .id(tabID(for: category))
                                    .containerRelativeFrame(.horizontal)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollPosition(id: $selectedTab)
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.paging)
                    .scrollClipDisabled()
                }
                .alert("Rename  Category", isPresented: $showRenameAlert){
                    TextField("Name", text: $editingName)
                    
                    Button("Save"){
                        guard let editingCategory else { return }
                        do {
                            try noteVM.renameCategory(editingCategory, name: editingName)
                        } catch {
                            showRenameError = true
                        }
                    }
                    
                    Button("Cancel", role: .cancel) { }
                }
            }
            .alert("Couldn’t rename category", isPresented: $showRenameError) {
                Button("OK") { }
            } message: { Text("The category name hasn’t changed. Please try again.") }
        }
    
    private var noteTabView: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 8){
                ForEach(Array(noteTabs.enumerated()), id: \.element?.id){ _, category in
                    
                    let isSelected = selectedTab == tabID(for: category)
                    
                    Text(category?.name ?? "All")
                        .font(.callout)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(minWidth: 44, maxWidth: 120)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .foregroundStyle(isSelected ? .primary : .secondary)
                        .glassEffect(isSelected ? .regular : .identity)
                        .onTapGesture {
                            withAnimation(.snappy) {
                                selectedTab = tabID(for: category)
                            }
                        }
                        .onLongPressGesture {
                            guard let category else { return }
                            editingCategory = category
                            editingName = category.name
                            showRenameAlert = true
                        }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
            .background(.gray.opacity(0.1), in: .capsule)
        }
    }
}

