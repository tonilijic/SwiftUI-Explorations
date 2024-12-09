//
//  ContentView.swift
//  ArcDragInteraction
//
//  Created by Toni on 04.02.2024.
//

import SwiftUI
import SpriteKit




struct ContentView: View {
    
    
    //variables
    @State private var scale: Double = 1.0
    @State private var location: CGPoint = CGPoint(x: UIScreen.main.bounds.width / 2, y: 350 )
    @State private var isDragging = false
    @State private var feedbackTriggered = false
    @State private var startingPoint = CGPoint.zero
    
    
    
    @State var scene = FidgetSpinner()
    

    
    
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            
            VStack {
                
                
                SpriteView(scene: scene, options: .allowsTransparency)
                
                    .frame(width: 225, height: 225)
                    .shadow(color: isDragging ? .black.opacity(0.7) : .clear, radius: 8, x: 0, y: 0)
                    .scaleEffect(scale)
                    .position(location)
                    
                
                //tap
                    .onTapGesture {
                        isDragging = true
                        if !feedbackTriggered {
                            feedbackTriggered = true
                        }
                        
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.6, blendDuration: 0)) {
                            scale = 1.35
                        }
                        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0)) {
                                isDragging = false
                                feedbackTriggered = false
                                scale = 1
                            }
                        }
                        
                        
                    }
                
                
              
              

                    //icon drag gesture
                    .gesture(
                        DragGesture()
                        
                            .onChanged { gesture in
                                
                                let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
                                
                                isDragging = true
                                location = gesture.location
                                
                                if !feedbackTriggered {
                                    feedbackGenerator.impactOccurred()
                                    feedbackTriggered = true
                                }
                                
                                
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.4)) {
                                    scale = 1.35
                                }
                                
                                
                            }
                        
                            .onEnded { gesture in
                                    
                               
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.4)) {
                                    isDragging = false
                                    location = CGPoint(x: UIScreen.main.bounds.width / 2, y: 350 )
                                    feedbackTriggered = false
                                    scale = 1
                                }
                                
                                
                            }
                    )
                
                
//                CustomTabBar()
            }
                
        }
        
        //angle velocity change on dragging
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    
                    scene.updateAngularImpulse(gesture)
                    
                }
       )
    }
}

    
#Preview {
    ContentView().preferredColorScheme(.light)
}
    
   


////custom tab view
//@ViewBuilder
//func CustomTabBar() -> some View {
//    HStack() {
//       
//        
//        
//        Image(systemName: "repeat")
//            .font(.system(size: 32))
//            .foregroundColor(.black)
//
//        Spacer()
//        
//        Image(systemName: "heart")
//            .font(.system(size: 28))
//            .foregroundColor(.black)
//        
//        
//        Spacer()
//        
//        Image(systemName: "bookmark")
//            .font(.system(size: 28))
//            .foregroundColor(.black)
//    }
//            
//    .frame(maxWidth: .infinity)
//    .foregroundStyle(Color.primary )
//    .padding(.top, 17)
//    .padding(.horizontal, 40)
//    .background(.ultraThinMaterial)
//        .overlay (
//            Rectangle()
//            .frame(height: 1)
//            .foregroundColor(Color.black.opacity(0.1))
//            .padding(.top, -26)
//            )
//}


//SpriteKit Scene
class FidgetSpinner: SKScene {
    
    var spriteNode: SKSpriteNode = SKSpriteNode(imageNamed: "pic")
    var startingPoint = CGPoint.zero
    
    // Tracking full rotations
    private var lastFullRotationAngle: CGFloat = 0
    private var fullRotationCount: Int = 0
    private let rotationThreshold: CGFloat = .pi * 2 // One full rotation
    
    // Haptic tracking
    private var lastHapticTime: TimeInterval = 0
    private let hapticCooldown: TimeInterval = 0.1
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        size = CGSize(width: 150, height: 150)
        scaleMode = .fill
        backgroundColor = .clear
        
        spriteNode.size = CGSize(width: 125, height: 125)
        spriteNode.physicsBody = SKPhysicsBody(circleOfRadius: 120)
        addChild(spriteNode)
        
        spriteNode.physicsBody?.pinned = true
        spriteNode.physicsBody?.angularDamping = 1.5
        spriteNode.physicsBody?.allowsRotation = true
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard let physicsBody = spriteNode.physicsBody else { return }
        
        // Current rotation and angular velocity
        let currentZRotation = spriteNode.zRotation
        let angularVelocity = physicsBody.angularVelocity
        
        // Check for full rotations
        checkFullRotation(currentTime, currentZRotation)
        
        // Stabilization logic
        let uprightThreshold: CGFloat = 0.3
        let stabilizationStrength: CGFloat = 2.0
        
        if abs(currentZRotation) > uprightThreshold || abs(angularVelocity) > 0.5 {
            let stabilizationTorque = -currentZRotation * stabilizationStrength
                - (angularVelocity * 0.5)
            
            physicsBody.applyTorque(stabilizationTorque)
        }
    }
    
    private func checkFullRotation(_ currentTime: TimeInterval, _ currentRotation: CGFloat) {
        // Calculate the change in rotation
        let rotationDelta = abs(currentRotation - lastFullRotationAngle)
        
        // Check if a full rotation has occurred
        if rotationDelta >= rotationThreshold {
            // Trigger haptic feedback if enough time has passed
            if currentTime - lastHapticTime >= hapticCooldown {
                // Trigger light intensity haptic
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.prepare()
                generator.impactOccurred(intensity: 1.0)
                
                // Update tracking variables
                lastFullRotationAngle = currentRotation
                fullRotationCount += 1
                lastHapticTime = currentTime
                
                // Optional: You can add multiple haptics or log rotation count
                print("Full rotation count: \(fullRotationCount)")
            }
        }
    }
    
    func updateAngularImpulse(_ gesture: DragGesture.Value) {
        var location = gesture.location
    
        let dx = location.x - spriteNode.position.x
        let dy = location.y - spriteNode.position.y
        
        startingPoint = CGPoint(x: dx, y: dy)

        if gesture.translation != .zero {
            location = self.convertPoint(fromView: location)
            var dx = location.x - spriteNode.position.x
            var dy = location.y - spriteNode.position.y
            
            // Determine the direction to spin the node
            let direction = sign(startingPoint.x * dy - startingPoint.y * dx)
            
            dx = gesture.velocity.width
            dy = gesture.velocity.height
            
            // Determine how fast to spin the node
            let speed = sqrt(dx * dx + dy * dy) * 0.002
            
            // Apply angular impulse
            spriteNode.physicsBody?.applyAngularImpulse(speed * direction)
        }
    }
}
