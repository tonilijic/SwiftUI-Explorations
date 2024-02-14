import SwiftUI
import SpriteKit

struct SceneView: View {
    
    
    //variables
    
    @State var particles = Particles()
    @State var isGold = true
    @State var isSilver = false
    @State var isBlended = false
    @State private var tappedPoint: CGPoint = .zero
    @State private var isDragging = false
    
    
    
    
    
    //view
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ZStack {
                
                SpriteView(scene: particles, options: .allowsTransparency)
                    .ignoresSafeArea()
                    .overlay(
                        LinearGradient(gradient: Gradient(colors: [.clear,.clear,.clear.opacity(0.2), .black.opacity(0.6), .black, .black]), startPoint: .top, endPoint: .bottom)
                            .blendMode(.darken)
                    )
                    .gesture(
                        SpatialTapGesture()
                            .onEnded { gesture in
                                
                                tappedPoint = CGPoint(x: gesture.location.x, y: gesture.location.y + 50)
                                let convertedPoint = particles.convertPoint(fromView: tappedPoint)
                                self.particles.gravity.position = convertedPoint
                                self.particles.gravity.strength = -10
                                
                                Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
                                    self.particles.gravity.strength = 0
                                }
                            }
                    )
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                withAnimation(.spring()) {
                                    
                                    tappedPoint = CGPoint(x: gesture.location.x, y: gesture.location.y + 50)
                                    let convertedPoint = particles.convertPoint(fromView: tappedPoint)
                                    self.particles.gravity.position = convertedPoint
                                    self.particles.gravity.strength = -30
                                    self.particles.gravity.region = SKRegion(radius: 26)
                                    
                                    
                                }
                                withAnimation(.interactiveSpring()) {
                                    isDragging = true
                                }
                                
                            }
                            .onEnded { _ in
                                withAnimation(.spring()) {
                                    isDragging = false
                                    self.particles.gravity.strength = 0
                                    
                                }
                            }
                    )
                
                
                VStack {
                    
                    Spacer()
                    
                    HStack(spacing: 24) {
                        
                        Circle()
                            .fill(Gradient(colors: [Color("GYellow"), Color("Gold")]))
                            .frame(width: 30, height: 30)
                            .overlay(
                                Circle()
                                    .stroke(.white,lineWidth: isGold ? 2 : 0)
                                    .frame(width: isGold ? 36 : 34, height: isGold ? 36 : 34)
                            )
                            .onTapGesture {
                                withAnimation(.spring){
                                    isGold = true
                                    isSilver = false
                                    particles.turbStrength = 10
                                    particles.updateFieldTurbulence()
                                    
                                    Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false) { _ in
                                        particles.resetTurbulenceStrength()
                                        particles.updateParticlesColor()
                                    }
                                    
                                    particles.particleColore = .orange
                                }
                            }
                        
                        Circle()
                            .fill(Gradient(colors: [Color(.white), Color("DarkGrey")]))
                            .frame(width: 30, height: 30)
                            .overlay(
                                Circle()
                                    .stroke(.white,lineWidth: isSilver ? 2 : 0)
                                    .frame(width: isSilver ? 36 : 34, height: isSilver ? 36 : 34)
                            )
                            .onTapGesture {
                                withAnimation(.spring){
                                    isGold = false
                                    isSilver = true
                                    particles.turbStrength = 10
                                    particles.updateFieldTurbulence()
                                    
                                    Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false) { _ in
                                        particles.resetTurbulenceStrength()
                                        particles.updateParticlesColor()
                                        
                                    }
                                    
                                    particles.particleColore = .blue
                                }
                            }
                    }
                    .padding(.bottom, 20)
                }
            }
        }
    }
}


#Preview {
    SceneView()
}



//SK Secne

class Particles: SKScene, ObservableObject {
    
    @Published var particleName: String = "MyParticle.sks"
    @Published var particleColore: UIColor {
        didSet {
            updateParticlesColor()
        }
    }
    
    @Published var turbStrength: CGFloat {
        didSet {
            updateFieldTurbulence()
        }
    }
    
    
    @Published var falloffStrength: CGFloat {
        didSet {
            updateGravityField()
        }
    }
    
    @Published var fieldPosition: CGPoint
    
    var turbulence: SKFieldNode!
    var gravity: SKFieldNode!
    var emitterNode: SKEmitterNode!
    
    
    
    init(turbStrength: CGFloat = 0.0) {
        self.falloffStrength = 0.0
        self.turbStrength = turbStrength
        self.fieldPosition = .zero
        self.particleColore = .white
        super.init(size: CGSize(width: 300, height: 300))
        
        sceneDidLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func sceneDidLoad() {
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scaleMode = .resizeFill
        backgroundColor = .clear
        
        
        //particles
        
        emitterNode = SKEmitterNode(fileNamed: particleName)!
        emitterNode.particleColorSequence = nil
        emitterNode.particleColorBlendFactor = 0.3;
        emitterNode.particleColor = .orange
        emitterNode.particleSize = CGSize(width: 30, height: 30)
        emitterNode.position = CGPoint(x: frame.midX, y: frame.midY)
        emitterNode.advanceSimulationTime(5)
        
        addChild(emitterNode)
        
        
        //burst transition
        
        turbulence = SKFieldNode.turbulenceField(withSmoothness: 5, animationSpeed: 0.5)
        turbulence.strength = 0
        turbulence.position = CGPoint(x: 0, y: 0)
        
        addChild(turbulence)
        
        
        //attract or repel particles
        
        gravity = SKFieldNode.radialGravityField()
        gravity.falloff = -1
        gravity.strength = 0
        gravity.animationSpeed = 0.2
        gravity.region = SKRegion(radius: 30)
        
        addChild(gravity)
        
    }
    
    
    //SK Functions
    
    func updateFieldTurbulence() {
        turbulence.strength = Float(turbStrength)
    }
    
    
    func updateGravityField() {
        gravity.falloff = Float(falloffStrength)
    }
    
    
    func updateParticlesColor() {
        
        removeAllChildren()
        
        emitterNode.particleColorBlendFactor = 0.25;
        emitterNode.particleColor = particleColore
        
        addChild(emitterNode)
        addChild(gravity)
        addChild(turbulence)
        
        
    }
    
    
    func resetTurbulenceStrength() {
        turbStrength = 0
        updateFieldTurbulence()
    }
    
    
    
}



