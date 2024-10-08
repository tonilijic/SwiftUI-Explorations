//
//  Fidget.swift
//  ConfettiFidget
//
//  Created by Toni on 03.05.2024.
//

import SwiftUI
import SpriteKit





struct Fidget: View {
    
    
    // other variables
    
    
    @State private var isDragged = false
    @State private var dragRotationAngle: Angle = .degrees(-360)
    @State private var scale = 0.0
    @State private var floatingOffset: Double = -1.5
    @State private var feedbackTriggered = false
    @State private var location: CGPoint = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    
    @Binding var fidgetItem: FidgetItem
    @Binding var backgroundColor: BackgroundColor
    @Binding var showSpriteView: Bool
    @Binding var confetti: Confetti
    
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    
    
    
    
    
    var body: some View {
        
        ZStack {
            
            
            if isDragged {
                RoundedRectangle(cornerRadius: 20, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                    .frame(width: 82, height: 82)
                    .foregroundStyle(backgroundColor.color.opacity(backgroundColor == .sketch ? 0.04 : 0.03))
                    .overlay {
                        RoundedRectangle(cornerRadius: 20, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                            .stroke(backgroundColor.color.opacity(0.15), lineWidth: 1 )
                    }
            }
            
            
            Image(fidgetItem.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 105)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .shadow(color:.gray.opacity(0.25),radius: 6, x: 10, y: 12)
                .rotationEffect(dragRotationAngle, anchor: .center)
                .position(location)
            
            
            //floating animation
                .offset(x: 0, y: floatingOffset)
                .animation(
                    .easeInOut(duration: 1)
                    .delay(fidgetItem.delay)
                    .repeatForever(autoreverses: true),
                    value: floatingOffset
                )
                .onAppear {
                    
                    withAnimation(.easeInOut(duration: 0.5)) {
                        floatingOffset = 1.2
                        
                    }
                    
                    withAnimation(.spring(duration: 0.8)) {
                        scale = 1
                    }
                    
                }
            
                .gesture(
                    
                    DragGesture()
                    
                    
                        .onChanged { gesture in
                            
                            isDragged = true
                            
                            if !feedbackTriggered {
                                feedbackGenerator.impactOccurred()
                                feedbackTriggered = true
                            }
                            
                            self.confetti.positionConfetti = fidgetItem.anchor
                            
                            
                            withAnimation() {
                                dragRotationAngle = .degrees(1100)
                            }
                            
                            floatingOffset = -2
                            fidgetItem.zIndex = Double.greatestFiniteMagnitude
                            location = gesture.location
                        }
                    
                    
                        .onEnded { gesture in

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation(){
                                    showSpriteView = true
                                }
                                feedbackGenerator.impactOccurred()
                            }
                            
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)){
                                dragRotationAngle = .degrees(360)
                            }
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.55)) {
                                location = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                            }
                            
                            floatingOffset = 0
                            
                            
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(){
                                    showSpriteView = false
                                    
                                }
                            }
                            

                            //background circle color change
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                
                                withAnimation(.smooth){
                                    switch fidgetItem.image {
                                    case "sketch":
                                        backgroundColor = .sketch
                                        
                                    case "xcode":
                                        backgroundColor = .xCode
                                        
                                    case "figma":
                                        backgroundColor = .figma
                                        
                                    default: break
                                    }
                                    
                                    fidgetItem.zIndex = 0
                                    
                                    feedbackTriggered = false
                                }
                            }
                        }
                )
        }
        
    }
}

#Preview {
    ContentView()
}


