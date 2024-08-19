//
//  Home.swift
//  Paging Indicators
//
//  Created by Toni on 04.01.2024.
//

import SwiftUI

struct Home: View {
    @State private var colors: [Color] = [.blue, .orange, .purple, .gray]
    
    
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                VStack{
                    LazyHStack(spacing:0) {
                        ForEach(colors, id: \.self) { color in
                            RoundedRectangle(cornerRadius: 25)
                                .fill(color.gradient)
                                .padding(15)
                                .containerRelativeFrame(.horizontal)
                        }
                    }
                        
                        PageIndicator()
                     
                        
                    
                }
            
            }
            
            
            .scrollTargetBehavior(.paging)
            .scrollIndicators(.hidden)
            .frame(height: 300)
            
            Spacer()
            
        }
        .navigationTitle("Indicators")
    }

}

#Preview {
    ContentView()
}
