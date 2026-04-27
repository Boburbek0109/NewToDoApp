//
//  CustumTabView.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 4/26/26.
//

import SwiftUI
import SwiftData

struct CustomTabView: View {
    
    @EnvironmentObject var vm: TaskViewModel
    
    @State private var selectedTab: TabModel? = .all
    @Environment(\.colorScheme) private var scheme
    @State private var tabProgress: CGFloat = 0
    @State private var showAddTask = false
    @State private var newTask = ""
    @FocusState private var isTextFieldFocused: Bool
    
    
    var body: some View {
        VStack(spacing: 15){
            HStack{
                Button {
                    withAnimation(.bouncy) {
                        showAddTask.toggle()
                    }
                    isTextFieldFocused = showAddTask
                } label: {
                    Image(systemName: "plus")
                }
                Spacer()
                
//                Button {} label: {
//                    Image(systemName: "bell.badge")
//                }
            }
            .font(.title2)
            .overlay{
                Text("DailyTasks")
                    .font(.title3.bold())
            }
            .foregroundStyle(.primary)
            .padding(15)
            
            if showAddTask {
                HStack {
                    TextField("New task...", text: $newTask)
                        .textFieldStyle(.roundedBorder)
                        .focused($isTextFieldFocused)
                        .onSubmit(addTask)
                    
                    Button("Add", action: addTask)
                }
                .padding(.horizontal)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
            
            TasksTabView()
            
            GeometryReader{
                let size = $0.size
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0){
                        DailyTasks(tab: .all, showsNavigationChrome: false)
                            .id(TabModel.all)
                            .containerRelativeFrame(.horizontal)
                        
                        DailyTasks(tab: .active, showsNavigationChrome: false)
                            .id(TabModel.active)
                            .containerRelativeFrame(.horizontal)
                        
                        DailyTasks(tab: .completed, showsNavigationChrome: false)
                            .id(TabModel.completed)
                            .containerRelativeFrame(.horizontal)
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
            
        }
//        .frame(maxWidth: .infinity, minHeight: .infinity, alignment: .top)
        .background(.gray.opacity(0.1))
    }
    
    
    @ViewBuilder
    func TasksTabView() -> some View {
        HStack(spacing: 0){
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
        .tabMask(tabProgress)
        .background{
            GeometryReader{
                let size = $0.size
                let capsuleWidth = size.width / CGFloat(TabModel.allCases.count)
                
                Capsule()
                    .fill(scheme == .dark ? .black : .white)
                    .frame(width: capsuleWidth)
                    .offset(x: tabProgress * (size.width - capsuleWidth))
            }
        }
        .background(.gray.opacity(0.1), in: .capsule)
        .padding(.horizontal)
        
        
    }
     
    private func addTask() {
        vm.addTasks(from: newTask)
        newTask = ""
    }
}


#Preview {
    let container = try! ModelContainer(
        for: ModelTask.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let vm = TaskViewModel(context: container.mainContext)

    CustomTabView()
        .modelContainer(container)
        .environmentObject(vm)
}
