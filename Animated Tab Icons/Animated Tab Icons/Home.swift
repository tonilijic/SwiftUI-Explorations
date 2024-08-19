//
//  Home.swift
//  Animated Tab Icons
//
//  Created by Toni on 11.11.2023.
//

import SwiftUI

struct Home: View {
 
    
    @State private var activeTab: Tab = .settings
    
    @State private var allTabs: [AnimatedTab] = Tab.allCases.compactMap { tab -> AnimatedTab? in return .init(tab:tab)
    }
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $activeTab) {
                
                //my TabView
                
                NavigationStack {
                    VStack {
                 
                        
                    }
                    .navigationTitle(Tab.settings.title)
                    
                }
                .setUpTab(.settings)
                
                NavigationStack {
                    VStack {
                        
                        
                    }
                    .navigationTitle(Tab.chat.title)
                    
                }
                .setUpTab(.chat)
                
                
                
                NavigationStack {
                    VStack {
                        
                        
                    }
                    .navigationTitle(Tab.apps.title)
                    
                }
                .setUpTab(.apps)
                
                
                
                NavigationStack {
                    VStack {
                        
                        
                    }
                    .navigationTitle(Tab.profile.title)
                    
                }
                .setUpTab(.profile)
                
                
            }
            
    
            
            CustomTabBar()
            
        }
    }
    
    //custom tab view
    @ViewBuilder
    func CustomTabBar() -> some View {
        HStack(spacing:0) {
            ForEach($allTabs) { $animatedTab in
                let atab = animatedTab.tab
                
                VStack(spacing:4){
                    Image(systemName: atab.rawValue)
                        .font(.title2)
                        .symbolEffect(.bounce.up.byLayer, value: animatedTab.isAnimating)
                       
                    Text(atab.title)
                        .font(.caption2)
                        .textScale(.secondary)
                }
                
                .frame(maxWidth: .infinity)
                .foregroundStyle(activeTab == atab ? Color.primary : Color.gray)
                .padding(.top, 16)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.default, completionCriteria: .logicallyComplete, {
                        activeTab = atab
                        animatedTab.isAnimating = true
                    }, completion: {
                        
                        var transaction = Transaction()
                        transaction.disablesAnimations = true
                        withTransaction(transaction) {
                            animatedTab.isAnimating = nil
                        }//to reset animation and avoid two times playing
                    })
                    
                }
                
            }
        }
        .background(.bar)
    }
    
    
}

#Preview {
    ContentView()
}

extension View {
    @ViewBuilder
    func setUpTab(_ tab: Tab) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tag(tab)
            .toolbar(.hidden, for: .tabBar)
        
        
    }
}
