//
//  PageIndicator.swift
//  Paging Indicators
//
//  Created by Toni on 04.01.2024.
//

import SwiftUI

struct PageIndicator: View {
    
    var body: some View {
        
        GeometryReader {
            
            let width = $0.size.width
            
            if let scrollViewWidth = $0.bounds(of: .scrollView(axis: .horizontal))?.width,
               scrollViewWidth > 0 {
                
                let minX = $0.frame(in: .scrollView(axis: .horizontal)).minX
               
                
                let totalPages = Int(width / scrollViewWidth)
                
                let progress = -minX/scrollViewWidth
                let activeIndex = Int(progress)
                let nextIndex = Int(progress.rounded(.awayFromZero))
                
                let indicatorProgress = progress - CGFloat(activeIndex)
                
                //Indicators Width
                let nextIndicatorWidth = indicatorProgress * 24
                let currentIndicatorWidth = 24 - (nextIndicatorWidth)
             
              
                
                
                HStack(spacing: 10) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        Capsule()
                            .fill(.black.opacity(0.2))
                            .frame(width: 10 + (activeIndex == index ? currentIndicatorWidth : nextIndex == index ? nextIndicatorWidth : 0), height: 10)
                    }
                    
                }
//                .overlay(content: {
//                    VStack{
//                        Text("\(progress)")
//                           
//                        
//                        Text("\(minX)")
//                        
//                        Text("\(scrollViewWidth)")
//                    }
//                    .offset(y: -100)
//                })
//                    
                    
                    .frame(width: scrollViewWidth)
                    .offset(x: -minX)
                    
                

                }
            
            }
        
     
        
            
        .frame(height: 30)
            
            
        }
    }

#Preview {
    ContentView()
}
