//
//  CustomTabView.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 4/26/26.
//

import SwiftUI
import SwiftData

struct CustomTabView: View {
    
    @EnvironmentObject var taskVM: TaskViewModel
    
    @State private var selectedTab: TabModel? = .all
    @Environment(\.colorScheme) private var scheme
    @State private var tabProgress: CGFloat = 0
    
    @Binding var selectedTasks: Set<String>
    @Binding var isSelected: Bool
    
    
    var body: some View {
            VStack(spacing: 15){
                
                tasksTabView
                
                GeometryReader{
                    let size = $0.size
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 0){
                            ForEach(TabModel.allCases, id: \.self){ tab in
                                TaskPageView(tab: tab, selectedTasks: $selectedTasks, isSelected: $isSelected)

                                    .id(tab)
                                    .containerRelativeFrame(.horizontal)
                            }
                        }
                        .scrollTargetLayout()
                        .offsetX { value in
                            let progress = -value / (size.width * CGFloat(TabModel.allCases.count - 1))
                            
                            tabProgress = max(min(progress, 1), 0)
                        }
                    }
                    
                    .scrollPosition(id: $selectedTab)
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.paging)
                    .scrollClipDisabled()
                }
                .background(.gray.opacity(0.1))
            }
        }
    
    
    private var tasksTabView: some View {
        HStack{
            ForEach(TabModel.allCases, id: \.rawValue){ tab in
                HStack(spacing: 10) {
                    Image(systemName: tab.systemImage)
                    
                    Text(tab.rawValue)
                        .font(.callout)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .contentShape(.capsule)
                .onTapGesture {
                    withAnimation(.snappy) {
                        selectedTab = tab
                    }
                }
            }
        }
        .tabMask(tabProgress, tabCount: TabModel.allCases.count)
        .background{
            GeometryReader{
                let size = $0.size
                let capsuleWidth = size.width / CGFloat(TabModel.allCases.count)
                
                Capsule()
                    .fill(scheme == .dark ? .black : .white)
                    .frame(width: capsuleWidth)
                    .offset(x: tabProgress * (size.width - capsuleWidth))
            }
            .glassEffect(.regular)
        }
        .background(.gray.opacity(0.1), in: .capsule)
        .padding(.horizontal)
    }
}



#Preview {
    let container = try! ModelContainer(
        for: ModelTask.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let taskVM = TaskViewModel(context: container.mainContext)

    CustomTabView(
        selectedTasks: .constant(Set<String>()),
        isSelected: .constant(false))
        .modelContainer(container)
        .environmentObject(taskVM)
}
