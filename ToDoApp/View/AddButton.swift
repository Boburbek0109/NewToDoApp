//
//  AddButton.swift
//  ToDo
//
//  Created by Bobur Sobirjanov on 4/9/26.
//

import SwiftUI

struct AddButton: View {
    
    @State private var showButton = false
    
    var body: some View {
        
        ZStack{
            Group{
                Button(action: { showButton.toggle() } ) {
                    Image(systemName: "pencil.tip.crop.circle")
                        .padding(24)
                        .rotationEffect(Angle
                            .degrees(showButton ? 0 : -90))
                }
                .background(Circle()
                    .fill(Color.black)
                    .opacity(0.8)
                    .shadow(radius: 8, x: 4, y: 4))
                .opacity(showButton ? 1 : 0)
                .offset(x: 0, y: showButton ? -80 : 0)
                
                Button(action: { showButton.toggle() } ) {
                    Image(systemName: "trash.circle")
                        .padding(24)
                        .rotationEffect(Angle
                            .degrees(showButton ? 0 : 90))
                }
                .background(Circle()
                    .fill(Color.black)
                    .opacity(0.8)
                    .shadow(radius: 8, x: 4, y: 4))
                .opacity(showButton ? 1 : 0)
                .offset(x: showButton ? -80 : 0, y: 0)
                
                
                
                Button(action: { showButton.toggle() } ) {
                    Image(systemName: "plus")
                        .padding(24)
                        //.font(.system(size: 40))
                        .rotationEffect(Angle(degrees: showButton ? 45 : 0))
                }
                .background(Circle()
                    .fill(Color.black))
                .shadow(radius: 8, x: 4, y: 4)
            }
            .padding(.horizontal)
            .tint(.white)
            .animation(.default, value: showButton)
        }
        .font(.title3)
    }
}


#Preview {
    AddButton()
}
