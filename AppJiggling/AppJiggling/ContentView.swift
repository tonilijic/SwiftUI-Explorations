//
//  ContentView.swift
//  AppJiggling
//
//  Created by Toni on 18.04.2024.
//

import SwiftUI

struct ContentView: View {
    
    
    @State private var isEditMode = false
    
    
    var body: some View {
        
        ZStack {
            
            VStack {
                
                Spacer()
                
                HDock(isEditMode: $isEditMode)
                
            }
            
            .padding(.bottom, 13.5)
   
        }
        
        .background(
            Image("wallpaper")
                .resizable()
        )
        .frame(height: .infinity)
        .ignoresSafeArea()
        .onTapGesture { withAnimation(.snappy){ isEditMode = false }
            
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}
