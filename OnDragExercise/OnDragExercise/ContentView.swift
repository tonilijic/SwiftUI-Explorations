//
//  ContentView.swift
//  OnDragExercise
//
//  Created by Toni on 18.01.2024.
//

import SwiftUI

//distance between points in 2D
func getDistance(p1: CGPoint, p2: CGPoint) -> Float {
    return hypotf(Float(p1.x - p2.x), Float(p1.y - p2.y))
}


// equation
func scale(inputMins: CGFloat, inputMax: CGFloat, outputMin: CGFloat, outputMax: CGFloat, value: CGFloat) -> CGFloat {
    return outputMin + (outputMax - outputMin) * (value - inputMins) / ( inputMax - inputMins)
    
}





//variables
var rows: Int = 24
var columns: Int = 20
var spacing: Int = 6
var padding: Int = 4
var size: Int = 8


struct ContentView: View {
    
    
    
    @State var selectedPoint: CGPoint = .zero
    @State var isDragging = false
    
    
    func getOffset(row: Int, column: Int, selectedPoint: CGPoint, isDragging: Bool) -> CGPoint {
        
        //starting point coordinates
        let p1: CGPoint = CGPoint(
            x: Double(row * ( size + spacing)),
            y: Double(column * ( size + spacing))
        )
        
        //selected/dragged point coordinates
        let p2 = selectedPoint
        let distance = getDistance(p1: p1, p2: p2)
        
        
        var normalizedDistance = scale(inputMins: 0, inputMax: 100, outputMin: 0, outputMax: 2, value: CGFloat(distance))
        
        normalizedDistance = min(1, max(0, normalizedDistance))
        
        
        if isDragging {
            
           
            let x = (p1.x * (normalizedDistance)) + (p2.x * (1 - normalizedDistance))
            let y = (p1.y * normalizedDistance) + (p2.y * (1 - normalizedDistance))
            
            return CGPoint(x: x, y: y)
        } else {
            return p1
        }
    }
    

    
    
    
    
    
    
    
    func getFill(column: Int, row: Int, selectedPoint: CGPoint, isDragging: Bool) -> Color {
        
        let p1: CGPoint = CGPoint(
            x: Double(row * (size + spacing)),
            y: Double(column * (size + spacing))
        )
        
        
        let p2 = selectedPoint
        
        let distance = getDistance(p1: p1, p2: p2)
        
        var normalizedDistance = scale(inputMins: 0, inputMax: 1000, outputMin: 0, outputMax: 1, value: CGFloat(distance))
        
        normalizedDistance = min(1, max(0, normalizedDistance))
        
        if isDragging && normalizedDistance <= 0.05 {
            return Color.white
           
        } else {
            return Color.white.opacity(0.4)
        }
    }
    
    
    
    
    
    
    
    
    var body: some View {
        
        
        
        ZStack {
            Color(.black).ignoresSafeArea()
            
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { gesture in
                            withAnimation(.spring()) {
                                selectedPoint = CGPoint(x: gesture.location.x, y: gesture.location.y)
                            }
                            withAnimation(.interactiveSpring()) {
                                isDragging = true
                            }
                            
                        }
                        .onEnded { _ in
                            withAnimation(.spring()) {
                                isDragging = false
                            }
                        }
                )
            
            ZStack {
                ForEach((0...rows - 1),id: \.self) { row in
                    ForEach((0...columns - 1), id: \.self) {column in
                        RoundedRectangle(cornerRadius: 3, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                            .fill(getFill(column: column, row: row, selectedPoint: selectedPoint, isDragging: isDragging))
                            .frame(width: CGFloat(size), height: CGFloat(size))
                           
                            .position(getOffset(row: row,column: column, selectedPoint: selectedPoint, isDragging: isDragging))
                        
                    }
                }
            }
        }
        
        .offset(x: 37, y: 240)
        .scaleEffect(1)
        .preferredColorScheme(.dark)
        
    }
    
}

#Preview {
    ContentView()
}
