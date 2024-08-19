//
//  ContentView.swift
//
//  Created by Toni on 13.12.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var is2024: Bool = false
    
    
    var body: some View {
        
        VStack{
            
            Spacer()
            
            Picker("", selection: $is2024){
                Text("2023")
                    .tag(false)
                
                Text("2024")
                    .tag(true)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal,100)
            
            
            Spacer()
            
            
            VStack {
                
                Button("Manage"){
                    
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .foregroundColor(.white)
                .font(.title3)
                .fontWeight(.medium)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay{
                    RoundedRectangle(cornerRadius: 12)
                        .inset(by: 2)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [.white.opacity(0.3), .clear]),
                                startPoint: UnitPoint(x: 0.5, y: 0),
                                endPoint: UnitPoint(x: 0.5, y: 0.5)
                            ), lineWidth: is2024 ? 2 : 0
                        )
                }
                .overlay{
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: is2024 ? [Color("DarkBlue"), .blue] : [.blue, .blue]),
                                startPoint: UnitPoint(x: 0.5, y: 0),
                                endPoint: UnitPoint(x: 0.5, y: 0.5)
                            ), lineWidth: is2024 ? 2 : 0
                        )
                    
                }
                .padding(.vertical, 20)
                
                Button("Manage"){
                    
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .foregroundColor(.black)
                .font(.title3)
                .fontWeight(.medium)
                .background(is2024 ? .gray.opacity(0.08) : .gray.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay{
                    RoundedRectangle(cornerRadius: 12)
                        .inset(by: 2)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [.white, .clear]),
                                startPoint: UnitPoint(x: 0.5, y: 0),
                                endPoint: UnitPoint(x: 0.5, y: 0.5)
                            ), lineWidth: is2024 ? 2 : 0
                        )
                }
                .overlay{
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.gray.opacity(0.2), lineWidth: is2024 ? 2 : 0
                        )
                    
                }
                
                
            }
            .animation(.default, value: is2024)
            Spacer()
            Spacer()
          
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
