//
//  ContentView.swift
//  KeyframeChallenge
//
//  Created by Toni on 14.12.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var startKeyframeAnimation: Bool = false
    @State private var isclicked: Bool = false
    
    var body: some View {
        VStack{
            Spacer()
            
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                
                
                Ellipse()
                    .frame(width: 75, height: 20)
                    .foregroundStyle(.gray)
                    .keyframeAnimator(initialValue: Keyframe(), trigger: startKeyframeAnimation) { view, frame in
                        
                        view
                            .scaleEffect(frame.scale)
                            .opacity(frame.reflectionOpacity)
                        
                        
                    } keyframes: { frame in
                        
                        //scale
                        KeyframeTrack(\.scale){
                            CubicKeyframe(1.2, duration: 0.1)
                            CubicKeyframe(0.4, duration: 0.2)
                            CubicKeyframe(0.4, duration: 0.65)
                            CubicKeyframe(1.6, duration: 0.25)
                            
                        }
                        
                        //opacity
                        KeyframeTrack(\.reflectionOpacity){
                            CubicKeyframe(1, duration: 0.1)
                            CubicKeyframe(0.4, duration: 0.85)
                            CubicKeyframe(0.8, duration: 0.2)
                            CubicKeyframe(0, duration: 0.05)
                            
                        }
                        
                        //blur
                        
                    }
                
                Rectangle()
                    .frame(width: 150, height: 150)
                    .foregroundStyle(.orange)
                    .cornerRadius(16)
                    .keyframeAnimator(initialValue: Keyframe(), trigger: startKeyframeAnimation) { view, frame in
                        
                        view
                            .scaleEffect(frame.scale)
                            .rotationEffect(frame.rotation, anchor: .center)
                            .offset(y: frame.offsetY)
                        
                    } keyframes: { frame in
                        
                        //offsetY
                        KeyframeTrack(\.offsetY){
                            CubicKeyframe(10, duration: 0.15)
                            SpringKeyframe(-100, duration: 0.3, spring: .bouncy)
                            CubicKeyframe(-100, duration: 0.4)
                            SpringKeyframe(0, duration: 0.3, spring: .bouncy)
                            
                        }
                        
                        //scale
                        KeyframeTrack(\.scale){
                            CubicKeyframe(0.9, duration: 0.15)
                            CubicKeyframe(1.2, duration: 0.3)
                            CubicKeyframe(1.2, duration: 0.3)
                            CubicKeyframe(1, duration: 0.3)
                            
                        }
                        
                        //rotation
                        KeyframeTrack(\.rotation){
                            CubicKeyframe(.zero, duration: 0.15)
                            CubicKeyframe(.zero, duration: 0.3)
                            CubicKeyframe(.init(degrees: 180), duration: 0.25)
                         
                        }
                        
                    }
//                    .onTapGesture(perform: {
//                        startKeyframeAnimation.toggle()
//                    })
            }
            
            Spacer()
            
            Button("START"){
                startKeyframeAnimation.toggle()
                withAnimation(.smooth){
                    isclicked.toggle()
                }
                
            } 
            .buttonRepeatBehavior(.enabled)
            .padding(.horizontal,40).padding(.vertical,16)
            .foregroundStyle(.white)
            .font(.headline).fontWeight(.semibold)
            .background(isclicked ? .blue : .blue.opacity(0.8))
            .cornerRadius(8)
           
        }
    }
}


#Preview {
    ContentView()
}

struct Keyframe {
    var scale: CGFloat = 1
    var offsetY: CGFloat = 0
    var rotation: Angle = .zero
    var reflectionOpacity: CGFloat = 1
}
