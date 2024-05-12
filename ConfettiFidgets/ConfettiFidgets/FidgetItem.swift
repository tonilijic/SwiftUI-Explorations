//
//  FidgetItem.swift
//  ConfettiFidget
//
//  Created by Toni on 09.05.2024.
//


import SwiftUI


struct FidgetItem: Identifiable {
    let id = UUID()
    let image: String
    let delay: Double
    let rotationDegrees: Angle
    let offset: CGSize
    let transitionOffset : CGSize
    var zIndex: Double = 0.0
    var introRotation : Angle
}



enum BackgroundColor {
    case sketch
    case xCode
    case figma
    
    var color: Color {
        switch self {
            
        case .sketch:
            return .orange
            
        case .xCode:
            return .blue
            
        case .figma:
            return .purple
        }
    }
}


