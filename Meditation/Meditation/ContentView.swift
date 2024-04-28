//
//  ContentView.swift
//  Meditation
//
//  Created by Toni on 29.11.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var color: [Color] = [.blue, .mint, .green, .yellow, .orange, .pink, .red, .purple, .indigo, .cyan]
    @State private var index: Int = 0
    @State private var scaleUPDown = false
    @State private var rotateInOut = false
    @State private var moveInOut = false
    
    var body: some View {
        ZStack {
            
           //first pair or circles
            ZStack {
                ZStack {
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: [color[index], .white]), startPoint: .top, endPoint: .bottom))
                        .frame(width: 120, height: 120)
                        .offset(y: moveInOut ? -60 : 0)
                    
                    Circle().fill(LinearGradient(gradient:Gradient(colors: [color[index], .white]), startPoint: .bottom, endPoint: .top))
                        .frame(width: 120, height: 120,                           alignment: .center)
                        .offset(y: moveInOut ? 60 : 0)
                }.opacity(0.5)
            }
            
            // Second pair of circles
            ZStack {
                ZStack {
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: [color[index], .white]), startPoint: .top, endPoint: .bottom))
                        .frame(width: 120, height: 120)
                        .offset(y: moveInOut ? -60 : 0)
                    
                    Circle().fill(LinearGradient(gradient:Gradient(colors: [color[index], .white]), startPoint: .bottom, endPoint: .top))
                        .frame(width: 120, height: 120,                           alignment: .center)
                        .offset(y: moveInOut ? 60 : 0)
                }
                .opacity(0.5)
                .rotationEffect(.degrees(60))
            }
            
            // Third pair of circles
            ZStack {
                ZStack {
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: [color[index], .white]), startPoint: .top, endPoint: .bottom))
                        .frame(width: 120, height: 120)
                        .offset(y: moveInOut ? -60 : 0)
                    
                    Circle().fill(LinearGradient(gradient:Gradient(colors: [color[index], .white]), startPoint: .bottom, endPoint: .top))
                        .frame(width: 120, height: 120,                           alignment: .center)
                        .offset(y: moveInOut ? 60 : 0)
                }
                .opacity(0.5)
                .rotationEffect(.degrees(120))
            }
           
        }
        .rotationEffect(.degrees(rotateInOut ? 90 : 0))
        .scaleEffect(scaleUPDown ? 1 : 1/8)
        .animation(Animation.easeInOut.repeatForever(autoreverses: true).speed(1/8),value: scaleUPDown)

        .onAppear{
            scaleUPDown.toggle()
            rotateInOut.toggle()
            moveInOut.toggle()
            
            Timer.scheduledTimer(withTimeInterval: 5.65, repeats: true) { timer in
                           withAnimation {
                               // Generate a random index
                             
                               let newIndex = (index + 1) % color.count
                                       index = newIndex
                           }
                       }
            
            
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}
