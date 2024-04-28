//
//  App.swift
//  AppJiggling
//
//  Created by Toni on 18.04.2024.
//

import SwiftUI



struct Apps: View {
    
    //variables
    @Binding var apps: [String]
    @Binding var isEditMode: Bool
    @Binding var shakingDegrees: Double
    @Binding var isWiggling: Bool
    @Binding var dockDelay: Double
    

    @State private var feedbackTriggered = false
    @State private var isDeleted = false
    @State private var scale = 1.0
    @State private var isSelected = false
    
    
    let appNames: [String]
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    //for detecting color schemes
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ForEach(appNames, id: \.self) { appName in

                
                ZStack {
               
                        Image(appName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .scaleEffect(scale)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        
                        
                        //minus sign
                        
                        if isEditMode {
                            Image(systemName: "minus.circle.fill")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.black, Color(colorScheme == .dark ? .systemGray : .systemGray5))
                                .font(.system(size: 24))
                                .foregroundStyle(Color(.systemGray))
                                .offset(x: -28, y: -28)
                                .transition(.asymmetric(
                                    insertion: .scale(scale: 0, anchor: .init(x: -0.5, y: -0.5)),
                                    removal: .scale(scale: 1, anchor: .init(x: -0.5, y: -0.5))
                                ))
                                .onTapGesture {
                                    
                                    dockDelay = 0.3
                                        
                                    withAnimation(.easeInOut(duration: 0.3).delay(0.08)){
                                        
                                        remove(appName: appName)
                                        
                                    }
                                }
                        }
                    
                    
                        //notifications indicator
                        
             
                        if (appName == "messages" || appName == "Phone" ) && !isEditMode {
                            
                            Text(appName == "messages" ? "1" : "32")
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .background(
                                    Capsule()
                                        .fill(.red)
                                        .frame(height: 24)
                                )
                                .offset(x: 28, y: -28)
                                .scaleEffect(scale)
                                .transition(.asymmetric(
                                    insertion: .scale(scale: 0, anchor: .init(x: 1.5, y: -0.5)),
                                    removal: .scale(scale: 1, anchor: .init(x: 1.5, y: -0.5))
                                ))
                        }
                    }         
            }
            
            
            //edit mode ON -> icons started jiggling
            .onTapGesture {
                //to unblock scrollView
                
            }
            
            
            //selection
            .onLongPressGesture(minimumDuration: 0.3) {
                
                
                if !isEditMode {
                    //shaking restart
                    if shakingDegrees >= 4 {
                        shakingDegrees = shakingDegrees - 4
                    }
                    
                    
                    withAnimation(.spring(response: 0.5, dampingFraction: 1)) {
                        scale = isEditMode ? 1 : 1.1
                        feedbackGenerator.impactOccurred()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        
                        withAnimation(.default) {
                            isEditMode = true
                            feedbackGenerator.impactOccurred()
                            scale = 1
                            
                        }
                        
                        
                        updateShakingDegrees(isEditMode: isEditMode)
                        
                        
                    }
                }
            }
        
    }
    
    .frame(width: 60, height: 60)
}


//functions
func updateShakingDegrees(isEditMode: Bool) {
    
    
    if isEditMode {
        shakingDegrees += 4
        isWiggling = true
    }
    
    
    if !isEditMode {
        shakingDegrees = shakingDegrees
        isWiggling = false
    }
    
}


    func remove(appName: String) {
        if let index = apps.firstIndex(of: appName) {
            apps.remove(at: index)
        }
    }

}


#Preview {
    ContentView()
}



