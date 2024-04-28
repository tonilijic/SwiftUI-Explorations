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
                
                    .frame(width: 200, height: 200)
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
                
                
                CustomTabBar()
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
    
   


//custom tab view
@ViewBuilder
func CustomTabBar() -> some View {
    HStack() {
       
        
        
        Image(systemName: "repeat")
            .font(.system(size: 28))
            .foregroundColor(.black)

        Spacer()
        
        Image(systemName: "heart")
            .font(.system(size: 28))
            .foregroundColor(.black)
        
        
        Spacer()
        
        Image(systemName: "bookmark")
            .font(.system(size: 28))
            .foregroundColor(.black)
    }
            
    .frame(maxWidth: .infinity)
    .foregroundStyle(Color.primary )
    .padding(.top, 17)
    .padding(.horizontal, 40)
    .background(.ultraThinMaterial)
        .overlay (
            Rectangle()
            .frame(height: 1)
            .foregroundColor(Color.black.opacity(0.1))
            .padding(.top, -26)
            )
}


//SpriteKit Scene
class FidgetSpinner: SKScene {
    
    var spriteNode: SKSpriteNode = SKSpriteNode(imageNamed: "pic")
    var startingPoint = CGPoint.zero
    
    
    override func didMove(to view: SKView) {
        
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        size = CGSize(width: 150, height: 150)
        scaleMode = .fill
        backgroundColor = .clear
        
        
        //physics node
        
        spriteNode.size = CGSize(width: 125, height: 125)
        spriteNode.physicsBody = SKPhysicsBody(circleOfRadius: 120)
        addChild(spriteNode)
        
        spriteNode.physicsBody?.pinned = true
        spriteNode.physicsBody?.angularDamping = 0.5
        
    }
    
   
    
    func updateAngularImpulse(_ gesture: DragGesture.Value) {
        
        var location = gesture.location
    
        let dx = location.x - spriteNode.position.x
        let dy = location.y - spriteNode.position.y
        
        startingPoint = CGPoint(x: dx, y: dy)
        print("text \(spriteNode.position)")

        
        if gesture.translation != .zero {
            var location = gesture.location
            location = self.convertPoint(fromView: location)
            var dx = location.x - spriteNode.position.x
            var dy = location.y - spriteNode.position.y
            
            // Determine the direction to spin the node
            let direction = sign(startingPoint.x * dy - startingPoint.y * dx)
            
            dx = gesture.velocity.width
            dy = gesture.velocity.height
            
            // Determine how fast to spin the node. Optionally, scale the speed
            let speed = sqrt(dx * dx + dy * dy) * 0.002
            
            // Apply angular impulse
            spriteNode.physicsBody?.applyAngularImpulse(speed * direction)
            
        }
        
    }
     
}




