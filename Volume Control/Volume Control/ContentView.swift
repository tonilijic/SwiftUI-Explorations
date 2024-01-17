//
//  ContentView.swift
//  Volume Control
//
//  Created by Toni on 05.01.2024.
//

import SwiftUI



struct iOsSlider: View {
    
    
    //constants
    
    enum Const {
        static let shapeSize: CGSize = .init(width: 80.0, height: 240.0)
        static let cornerRadius: CGFloat = 25.0
    }
    
    
    //variables
    
    @State var value = 0.0
    @State var hScale = 1.0
    @State var vScale = 1.0
    @State var vOffset: CGFloat = 0.0
    @State var startValue: CGFloat = 0.0
    @State var anchor: UnitPoint = .center
    @State var isTouching = false
    
    
    
    
    var body: some View {
        
        ZStack {
            
            Color.black.ignoresSafeArea()
            
            VStack {
                
                slider
                    .clipShape(RoundedRectangle(cornerRadius: Const.cornerRadius, style: .continuous))
                
                //feel free to adjust shadow radius as you like
                    .shadow(color: .orange.opacity(value),radius: (80*value))
                
                    .frame(width: Const.shapeSize.width, height: Const.shapeSize.height)
                    .scaleEffect(x: hScale, y: vScale, anchor: anchor)
                    .offset(x:0, y:vOffset)
                    .gesture(DragGesture(minimumDistance: 0)
                        .onChanged { drag in
                            if !isTouching {
                                startValue = value
                            }
                            
                            isTouching = true
                            
                            
                            //adjusting height of slider on drag
                            
                            var value = startValue - (drag.translation.height/Const.shapeSize.height)
                            self.value = min(max(value,0.0), 1.0)
                            
                            
                            //top - rubbery strech behavior
                            
                            if value > 1 {
                                value = sqrt(sqrt(sqrt(value)))
                                anchor = .bottom
                                vOffset = Const.shapeSize.height * (1 - value)/2
                                
                                
                            //bottom - rubbery stretch behavior
                                
                            } else if value < 0 {
                                value = sqrt(sqrt(sqrt(1 - value)))
                                anchor = .top
                                vOffset = -Const.shapeSize.height * ( 1 - value)/2
                                
                                
                            } else {
                                value = 1.0
                                anchor = .center
                                
                            }
                            
                            vScale = value
                            hScale = 2 - value
                            
                            
                        }
                             
                        // end of interaction - reset
                             
                        .onEnded {_ in
                            isTouching = false
                            vScale = 1.0
                            hScale = 1.0
                            anchor = .center
                            vOffset = 0.0
                        })
            }
            .animation(isTouching ? .none : .spring, value: vScale)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    
    @ViewBuilder
    var slider: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.gray.opacity(0.1))
            VStack {
                
                Spacer()
                    .frame(minHeight: 0)
                
                Rectangle()
                    .frame(width: Const.shapeSize.width, height: value * Const.shapeSize.height)
                    .foregroundStyle(.orange.gradient)
                
            }
        }
    }
}


#Preview {
    iOsSlider()
}


