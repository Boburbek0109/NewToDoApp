//
//  QuickNote.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 4/9/26.
//

import SwiftUI
import Combine

struct QuickNote: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: TaskViewModel
    
    @State private var inputText = ""

    var body: some View {
        ZStack {
            Color.black
                .opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("Quick Note")
                    .font(.title2.weight(.semibold))

                TextField("Write something...", text: $inputText)
                    .font(.title3)
                    .padding(.horizontal, 18)
                    .frame(height: 58)
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .overlay {
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(.black.opacity(0.08), lineWidth: 1)
                    }

                Button {
                    vm.addTasks(from: inputText)
                    dismiss()
                } label: {
                    Text("Save")
                        .font(.headline)
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(.yellow.opacity(0.85))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                }
            }
            .padding(24)
            .frame(maxWidth: 340)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 28))
            .shadow(radius: 20)
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    let vm = TaskViewModel()
    QuickNote(vm: vm )
}
