//
//  ContentView.swift
//  Meatball
//
//  Created by Toni on 14.02.2024.
//

import SwiftUI
import CoreMotion

//gyroscope
class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    @Published var x = 0.0
    @Published var y = 0.0
    
    init() {
        
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] data, error in
            guard let motion = data?.attitude else {return}
            self?.x = motion.roll
            self?.y = motion.pitch
            
        }
    }
}



struct ContentView: View {
    
    
    @State private var dragOffset: CGSize = .zero
    @StateObject private var motion = MotionManager()
    @State private var animatedOffset: CGSize = .zero
    
    var body: some View {
        
        ZStack {
            Color.white.ignoresSafeArea()
            
            Meatball(dragOffset: dragOffset)
        }
    }
    
    
    @ViewBuilder
    func Meatball(dragOffset: CGSize) -> some View {
        
        //meatball shape
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.5, color: .black))
            context.addFilter(.blur(radius: 18))
            
            context.drawLayer { ctx in
                for index in [1, 2] {
                    if let resolvedView = context.resolveSymbol(id: index) {
                        ctx.draw(resolvedView, at: CGPoint(x: size.width / 2, y: size.height / 2))
                    }
                }
            }
        } symbols: {
            Circle()
                .fill(.white)
                .frame(width: 150, height: 150)
                .offset(.zero)
                .tag(1)
            
            Circle()
                .fill(.white)
                .frame(width: 150, height: 150)
                .offset(animatedOffset)
                .tag(2)
               
        }
        
        .onChange(of: motion.y) {
            withAnimation {
                self.animatedOffset = CGSize(width: CGFloat(motion.x), height: CGFloat(motion.y * 400))
            }
        }
    }
}

#Preview {
    ContentView()
}

