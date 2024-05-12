//
//  ContentView.swift
//  ConfettiFidget
//
//  Created by Toni on 02.05.2024.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    
    
    @State private var showIcons = false
    @State private var showCircle = false
    @State private var backgroundColor: BackgroundColor = .sketch
    @State private var fidgetItems: [FidgetItem] = [
        
        
        // Figma App Icon
        FidgetItem(
            image: "figma",
            delay: 0.0,
            rotationDegrees: .degrees(8),
            offset: CGSize(width: 80, height: -90),
            transitionOffset: CGSize(width: 60, height: -100),
            introRotation: .degrees(220)
          
        ),
        
        
        // Xcode App Icon
        FidgetItem(
            image: "xcode",
            delay: 0.05,
            rotationDegrees: .degrees(8),
            offset: CGSize(width: -85, height: 0),
            transitionOffset: CGSize(width: -80, height: 0),
            introRotation: .degrees(-220)
        
        ),
        
        // Sketch App Icon
        FidgetItem(
            image: "sketch",
            delay: 0.1,
            rotationDegrees: .degrees(-12),
            offset: CGSize(width: 60, height: 70),
            transitionOffset: CGSize(width: 80, height: 70),
            introRotation: .degrees(220)
       
        )
    ]
    
    
    var body: some View {
        
        
        ZStack {
            
            
            
            
            VStack {
                
                Text("Confetti Playground")
                    .offset(x:0, y: 120)
                    .foregroundStyle(.gray)
                    .font(.callout)
                
                Spacer()
                Spacer()
            }
            
            
            //background element
            if showCircle {
                Circle()
                    .frame(width: 280)
                    .foregroundStyle(backgroundColor.color.opacity(0.1))
                    .blur(radius: 14)
                    .transition(.scale(scale: 0, anchor: .center))
                
            }
            
            
            ZStack {
                
                ForEach($fidgetItems) { $fidgetItem in
                    Fidget(fidgetItem: $fidgetItem, backgroundColor: $backgroundColor)
                        .rotationEffect(showIcons ? fidgetItem.rotationDegrees : fidgetItem.introRotation)
                        .offset(fidgetItem.offset)
                        .zIndex(fidgetItem.zIndex)
                        .scaleEffect(showIcons ? 1 : 0)
                        .opacity(showIcons ? 1 : 0)
                }
            }
            
            .onAppear {
                
                // trigger for icon rotation
                withAnimation(.interpolatingSpring(stiffness: 30, damping: 60)) {
                    showIcons = true
                }
                
                // display bg circle
                withAnimation(.easeIn(duration: 0.6).delay(0.2)) {
                    showCircle = true
                }
            }
            
            
            
        }
        
        .background(.white)
        .ignoresSafeArea()
        
        
    }
}

#Preview {
    ContentView()
}







