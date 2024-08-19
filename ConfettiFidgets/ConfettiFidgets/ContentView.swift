//
//  ContentView.swift
//  ConfettiFidget
//
//  Created by Toni on 02.05.2024.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    
    
    @State private var showIcons = false
    @State private var showCircle = false
    @State private var confetti = Confetti()
    @State private var backgroundColor: BackgroundColor = .sketch
    @State private var fidgetItems: [FidgetItem] = [
        
        
        // Figma App Icon
        FidgetItem(
            image: "figma",
            delay: 0.0,
            rotationDegrees: .degrees(8),
            offset: CGSize(width: 80, height: -90),
            transitionOffset: CGSize(width: 60, height: -100),
            introRotation: .degrees(220),
            anchor: CGPoint(x: 80, y: 90)
          
        ),
        
        
        // Xcode App Icon
        FidgetItem(
            image: "xcode",
            delay: 0.05,
            rotationDegrees: .degrees(8),
            offset: CGSize(width: -85, height: 0),
            transitionOffset: CGSize(width: -80, height: 0),
            introRotation: .degrees(-220),
            anchor: CGPoint(x: -85, y: 0)
        
        ),
        
        // Sketch App Icon
        FidgetItem(
            image: "sketch",
            delay: 0.1,
            rotationDegrees: .degrees(-12),
            offset: CGSize(width: 60, height: 70),
            transitionOffset: CGSize(width: 80, height: 70),
            introRotation: .degrees(220),
            anchor: CGPoint(x: 60, y: -70)
       
        )
    ]
    @State private var showSpriteView = false
    
    var body: some View {
        
        
        ZStack {
            
            
            
            
            VStack {
                
                Text("Confetti Playground")
                    .offset(x:0, y: 120)
                    .foregroundStyle(.gray)
                    .font(.callout)
                
                Spacer()
                Spacer()
            }
            
            
            //background element
            if showCircle {
                Circle()
                    .frame(width: 280)
                    .foregroundStyle(backgroundColor.color.opacity(0.1))
                    .blur(radius: 14)
                    .transition(.scale(scale: 0, anchor: .center))
                
            }
            
            
            ZStack {
                
                ForEach($fidgetItems) { $fidgetItem in
                    Fidget(fidgetItem: $fidgetItem, backgroundColor: $backgroundColor, showSpriteView: $showSpriteView, confetti: $confetti)
                        .rotationEffect(showIcons ? fidgetItem.rotationDegrees : fidgetItem.introRotation)
                        .offset(fidgetItem.offset)
                        .zIndex(fidgetItem.zIndex)
                        .scaleEffect(showIcons ? 1 : 0)
                        .opacity(showIcons ? 1 : 0)
                }
            }
            
            
            .onAppear {
                
                // trigger for icon rotation
                withAnimation(.interpolatingSpring(stiffness: 30, damping: 60)) {
                    showIcons = true
                }
                
                // display bg circle
                withAnimation(.easeIn(duration: 1).delay(0.4)) {
                    showCircle = true
                }
            }
            
            if showSpriteView {
                withAnimation(.default) {
                    SpriteView(scene: confetti, options: .allowsTransparency)
                        .ignoresSafeArea()
                }
            }
            
            
        }
        .background(.white)
        .ignoresSafeArea()
        
        
    }
}

#Preview {
    ContentView()
}



// SK Scene

class Confetti: SKScene, ObservableObject {
    
    @Published var positionConfetti: CGPoint {
        didSet {
            updateConfettiPoisition()
        }
    }
    
    var emitterNode: SKEmitterNode!
    
    
    init(positionConfetti: CGPoint = CGPoint(x: 0, y: 0)) {
        self.positionConfetti = positionConfetti
        super.init(size: UIScreen.main.bounds.size)
        
        sceneDidLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sceneDidLoad() {
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scaleMode = .resizeFill
        backgroundColor = .clear
        
        
        emitterNode = SKEmitterNode(fileNamed: "Confetti.sks")!
        emitterNode.particleColorSequence = nil
        emitterNode.particleColorBlendFactor = 1
        emitterNode.particleAlphaRange = 1
        emitterNode.particleColorRedRange = 10
        emitterNode.particleColorBlueRange = 10
        emitterNode.particleColorGreenRange = 10
        emitterNode.particleSize = CGSize(width: 40, height: 20)
    }
    
    
    func updateConfettiPoisition() {
        
        removeAllChildren()
        
        emitterNode.particlePosition = positionConfetti
        
        addChild(emitterNode)
        
        sceneDidLoad()
        
    }
}


