//
//  NoteMovingTab.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 5/25/26.
//

import SwiftUI

struct NoteOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View{
    @ViewBuilder
    func noteOffsetX(completion: @escaping (CGFloat) -> ()) -> some View {
        self
            .overlay {
                GeometryReader {
                    let minX = $0.frame(in: .scrollView(axis: .horizontal)).minX
                    
                    Color.clear
                        .preference(key: NoteOffsetKey.self, value: minX)
                        .onPreferenceChange(NoteOffsetKey.self, perform: completion)
                }
            }
    }
    
    @ViewBuilder
    func noteTabMask(_ tabProgress: CGFloat, tabCount: Int) -> some View{
        ZStack{
            self
                .foregroundStyle(.gray)
            self
                .symbolVariant(.fill)
                .mask{
                    GeometryReader{
                        let size = $0.size
                        let capsuleWidth = size.width / CGFloat(tabCount)
                        
                        Capsule()
                            .frame(width: capsuleWidth)
                            .offset(x: tabProgress * (size.width - capsuleWidth))
                    }
                }
        }
    }
}

