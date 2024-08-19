//
//  Tab.swift
//  Animated Tab Icons
//
//  Created by Toni on 11.11.2023.
//

import SwiftUI

//Tabs

enum Tab: String, CaseIterable {
    case settings = "gear"
    case chat = "bubble.left.and.text.bubble.right"
    case apps = "square.3.layers.3d"
    case profile = "person.crop.circle"
    
    var title: String {
        switch self {
        case .settings:
            return "Settings"
        case .chat:
            return "Chat"
        case .apps:
            return "Apps"
        case .profile:
            return "Profile"
            
            
        }
    }
}

//Animated SF Tab

struct AnimatedTab: Identifiable {
    var id: UUID = .init()
    var tab: Tab
    var isAnimating: Bool?
}

