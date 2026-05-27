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
    @Environment(\.colorScheme) private var scheme
    
    @State private var selectedTab: NoteTab? = .all
    @State private var tabProgress: CGFloat = 0
    @State private var editingCategory: NoteCategory?
    @State private var editingName = ""
    @State private var showRenameAlert = false
     
    let searchText: String
    
    private var noteTabs: [NoteCategory?] {
        [nil] + noteVM.usedCategories
    }
    
    private func tabID(for category: NoteCategory?) -> NoteTab {
        if let category{
            return .category(category.id)
        }
        
        return .all
    }
    
    
    var body: some View {
            VStack(spacing: 15){
                
                noteTabView
                
                GeometryReader{ proxy in
                    let size = proxy.size
                    
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 0){
                            ForEach(Array(noteTabs.enumerated()), id: \.offset){ _, category in
                                NotePageView(searchText: searchText, category: category)

                                    .id(tabID(for: category))
                                    .containerRelativeFrame(.horizontal)
                            }
                        }
                        .scrollTargetLayout()
                        .offsetX { value in
                            let count = max(noteTabs.count - 1, 1)
                            let progress = -value / (size.width * CGFloat(count))
                            
                            tabProgress = max(min(progress, 1), 0)
                        }
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
                        noteVM.renameCategory(editingCategory, name: editingName)
                    }
                    
                    Button("Cancel", role: .cancel) { }
                }
            }
        }
    
    
    private var noteTabView: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 6){
                ForEach(Array(noteTabs.enumerated()), id: \.offset){ _, category in
                    
                    let isSelected = selectedTab == tabID(for: category)
                    
                    Text(category?.name ?? "All")
                        .font(.callout)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(minWidth: 44, maxWidth: 120)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 7)
                        .foregroundStyle(isSelected ? .primary : .secondary)
                        .background{
                            if isSelected {
                                Capsule()
                                    .fill(scheme == .dark ? .black : .white)
                                    .shadow(color: .black.opacity(0.12),radius: 8, x: 0, y:3)
                            }
                        }
                        .background(.gray.opacity(0.1), in: .capsule)
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
            .padding(.horizontal, 12)
        }

    }
}

