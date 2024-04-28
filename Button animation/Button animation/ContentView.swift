//
//  ContentView.swift
//  Button animation
//
//  Created by Toni on 13.08.23.
//

import SwiftUI




struct ContentView: View {
    
    @State private var isPressed = false
    @State private var isTapped = false
    @State private var greenbutton = false
    
    
    
    func toggleTwice() {
        isTapped.toggle()
        
        if isTapped == true {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isTapped.toggle()
                
            }
        }
        isPressed = false
        
    }
    
    
    var body: some View {
        
        
        ZStack{
            Color("toni.grey").ignoresSafeArea()
            
            Circle()
                .stroke(lineWidth: greenbutton ? 4 : 0)
                .frame(width: greenbutton ? 500 : 0, height: greenbutton ? 500 : 0)
                .foregroundColor(.black)
                .blur(radius: greenbutton ? 4 : 10)
                .opacity(greenbutton ? 0 : 1)
            
            
            Text("Button")
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .padding(.vertical, 20).padding(.horizontal,greenbutton ? 0 : 60)
                .background(greenbutton ? .black : .white)
                .foregroundColor(greenbutton ? Color.clear : .primary)
                .clipShape(RoundedRectangle(cornerRadius: greenbutton ? 100 : 16, style: .continuous))
                .shadow(
                    color: isPressed ? .black.opacity(0.6) : .black.opacity(0.2),
                    radius: isTapped ? 5 : (greenbutton ? 8 : 10),
                    x: greenbutton ? 0 : (isTapped ? 0 : (isPressed ? 0 : 20)),
                    y: greenbutton ? 0 : (isTapped ? 0 : (isPressed ? 0 : 20))
                    
                )
                .opacity(greenbutton ? 0 : 1)
                .scaleEffect(greenbutton ? 0 : (isTapped ? 0.9 : 1))
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            if isPressed == true {
                                isPressed = false
                            }
                            
                           isTapped = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                
                                if isTapped == true {
                                    isPressed = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                           greenbutton = true
                                }
                                
                                }
                                        
            
                                
                            }
               
                            }
    
             
                    
                        .onEnded { _ in
                          
                            if isPressed == false {
                                isTapped = false
                            }
               
        
                        }
                )
            
            
                
            
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0), value: isTapped)
        .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0), value: isPressed)
        .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0), value: greenbutton)
    }
}


                    

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
