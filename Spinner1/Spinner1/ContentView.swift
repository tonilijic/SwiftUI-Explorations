import SwiftUI



extension View {
 
    
    func glow(color: Color, radius: CGFloat) -> some View {
            self
                .shadow(color: color.opacity(1), radius: 4 * radius)
                .shadow(color: color.opacity(1), radius: 4 * radius)
        }
    
}





struct ContentView: View {
    
    @State private var count =  1
    @State private var animated: Bool = false
    
    var body: some View {
        
        ZStack {
            Color.black.ignoresSafeArea()
            
            
            
            ZStack {
                ForEach(0..<count, id: \.self) { i in
                    Circle()
                        .fill(.white)
                        .frame(width: 30, height: 30)
                    
                        // extension view, stacked two shadows modifiers
                        .glow(color: .orange, radius: 2)

                        .offset( 
                            x: -80 * cos(2 * .pi / Double(count)),
                            y: 80 * sin(2 * .pi / Double(count))
                        )
                        .rotationEffect(.degrees(360 / Double(count) * Double(i)))
                }
                
            }
            .rotationEffect(.degrees(animated ? 360 : 0))
            .animation(
                .linear(duration: pow(1.5, Double(count)))
                .repeatForever(autoreverses: false),
                value: animated
            )
            
        }
        
        
        .onTapGesture { count += 1 }
        .onAppear{ animated.toggle() }
        
        
    }
}

#Preview {
        ContentView()
    }

