//
//  Icons.swift
//  AppleTVLoader
//
//  Created by Toni on 22.01.2024.
//

import SwiftUI

//Tabs

enum Tab: String, CaseIterable {
    case vstack = "square.3.layers.3d"
    case hstack = "square.stack.3d.forward.dottedline"
    case circle = "circle.hexagonpath"

    
   
}

//Animated SF Tab

struct AnimatedTab: Identifiable {
    var id: UUID = .init()
    var tab: Tab
    var isAnimating: Bool?
}
