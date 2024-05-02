//
//  HDock.swift
//  AppJiggling
//
//  Created by Toni on 19.04.2024.
//

import SwiftUI

struct HDock: View {
    
    @State private var apps: [String] = [ "perplexity", "Phone", "messages","ia", "github", "onepass", "fantastical", "arc" ]
    
    //variables
    @Binding var isEditMode: Bool
    
    @State private var shakingDegrees = 0.0
    @State private var isWiggling = false

    @State private var dockDelay = 0.0
    @State private var delayedPadding: CGFloat = 0

    
    var body: some View {
        
        
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 20) {
            
            //tap inidicator
            if isEditMode {
                Circle()
                    .foregroundStyle(.ultraThinMaterial)
                    .frame(width:36)
                    .onTapGesture {
                        withAnimation(.snappy) {
                            isEditMode = false
                        }
                    }
            }
            
            let rows = Array(repeating: GridItem(.fixed(60), spacing: 30), count: isEditMode ? 4 : apps.count)
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                LazyVGrid(columns: rows, spacing: apps.count > 4 ? 19 : 0) {
                    
                    ForEach(Array(zip(apps.indices, apps)), id: \.1) { (index, app) in
                        
                        Apps(
                            apps: $apps,
                            isEditMode: $isEditMode,
                            shakingDegrees: $shakingDegrees,
                            isWiggling: $isWiggling,
                            dockDelay: $dockDelay,
                            appNames: [apps[index]]
                        )
                        
                        
//                        //drag n drop - feel free to try enabling it
                        
//                        .contentShape(.dragPreview, .rect(cornerRadius: 12, style: .continuous))
//                        .draggable(apps[index]) {
//                            
//                            Image(apps[index])
//                                .frame(width: 60, height: 60)
//                                .clipShape(RoundedRectangle(cornerRadius: 12, style:  .continuous))
//                                .onAppear {
//                                    currentlyDragging = apps[index]
//                                }
//                            
//                        }
//                        
//                        .dropDestination(for: apps.self) {
//                            
//                                let sourceIndex = apps.firstIndex(of: currentlyDragging)
//                                let destinationIndex = apps.firstIndex(of: apps[index]) {
//                                    
//                                    withAnimation(){
//                                        let sourceItem = apps.remove(at: sourceIndex)
//                                        apps.insert(sourceItem, at: destinationIndex)
//                                    }
//                                }
//                            }
                     
                        
                        
                        
                        
                        
                        // wiggle animation
                        
                        .offset(x: 0, y: isEditMode ? (isWiggling ? 1.1 : 0) : 0)
                        .animation(
                            .easeOut(duration: 0.2)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.12),
                            value: isWiggling
                        )
                        .rotationEffect(isEditMode ? .degrees(shakingDegrees) : .zero)
                        .animation(
                            .easeOut(duration: 0.12)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.12),
                            value: shakingDegrees
                        )
                        
                        //scroll animation
                        .scrollTransition { content, phase in
                            withAnimation(.interpolatingSpring(mass: 1, stiffness: 200, damping: 40, initialVelocity: 8)) {
                                content
                                    .scaleEffect(x: phase.isIdentity ? 1 : 0.6, y: phase.isIdentity ? 1 : 0.5)
                                    .offset(y: phase.isIdentity ? 0 : 10)
                            }
                            
                        }
                    }
                    
                    .transition(.scale(scale: 0, anchor: .center))
                    
                }
                
                //inner padding behavior
                .padding(.vertical,19)
                .padding(.horizontal, isEditMode ? dockPaddingWithDelay() : dockPadding())
                
            }
            
            
            //scroll behavior
            .scrollTargetLayout()
            .scrollDisabled(isEditMode || apps.count <= 4 )
            .scrollTargetBehavior(.viewAligned)
            
            //dock styling
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 41, style: .continuous))
            .padding(.horizontal, 12)
            
        }
    }
    
    
    //functions
    
    func dockPadding() -> CGFloat {
        
        let minPadding: CGFloat = 19
        
        if apps.count < 4 {
            
            let totalWidth = 368.0
            let itemWidth: CGFloat = 60
            let itemSpacing: CGFloat = 30
            let totalItemsWidth = (CGFloat(apps.count) * itemWidth) + (CGFloat(apps.count - 1) * itemSpacing)
            let padding = (totalWidth - totalItemsWidth) / 2
            
            return padding
            
        } else {
            
            return minPadding
        }
    }
    
    
    func dockPaddingWithDelay() -> CGFloat {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + dockDelay) {
            withAnimation(.snappy) {
                delayedPadding = dockPadding()
            }
        }
        
        return delayedPadding
    }
    
    
}


#Preview {
    ContentView()
}
