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
    @State private var startTime: Date? = nil
    

    
    init() {
        // Initialize with gold-like settings
        _particles = State(initialValue: Particles(turbStrength: 10))
        _particles.wrappedValue.particleColore = .orange
        _particles.wrappedValue.emitterNode.particleColorSequence = nil
       
 
    }
    
    func calculateDynamicRadius(startTime: Date?) -> CGFloat {
            guard let startTime = startTime else { return 0 }
        
        // Calculate drag duration
        let dragDuration = abs(startTime.timeIntervalSinceNow)
        
        // Start with a small radius and increase over time
        let startRadius: CGFloat = 4 // Very small initial radius
        let maxRadius: CGFloat = 24   // Your original maximum radius
        
      
        let radius = min(startRadius + CGFloat(dragDuration * 32), maxRadius)
        
        return radius
    }
    
    //view
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ZStack {
                
                SpriteView(scene: particles, options: .allowsTransparency)
                    .ignoresSafeArea()
                    .overlay(
                        LinearGradient(gradient: Gradient(colors: [.black,.black.opacity(0.8),.black.opacity(0.6), .clear,.clear,.black.opacity(0.25),.black.opacity(0.4), .black.opacity(0.45), .black.opacity(0.6), .black.opacity(0.65)]), startPoint: .top, endPoint: .bottom)
                            .blendMode(.darken)
                    )
                    .overlay(
                        LinearGradient(gradient: Gradient(colors: [.clear,.clear, .black, .black, .black]), startPoint: .top, endPoint: .bottom)
                            .blendMode(.overlay)
                    )
                    .gesture(
                        SpatialTapGesture()
                        .onEnded { gesture in
                    
                            self.particles.gravity.strength = 0
                                    self.particles.gravity.region = SKRegion(radius: 20)
                                    self.particles.gravity.position = .zero
                            
                            tappedPoint = CGPoint(x: gesture.location.x, y: gesture.location.y + 50)
                            print("Converted Tap Point: \(tappedPoint)")
                            
                            let convertedPoint = particles.convertPoint(fromView: tappedPoint)
                            print("Converted Scene Point: \(convertedPoint)")
                            
                            self.particles.gravity.position = convertedPoint
                            self.particles.gravity.strength = -40
                            
                            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
                                print("Resetting Gravity Strength")
                                self.particles.gravity.strength = 0
                            }
                        }
                    )
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                if startTime == nil {
                                    startTime = Date()
                                }
                                
                                withAnimation(.linear(duration: 0.1)) {
                                    tappedPoint = CGPoint(x: gesture.location.x, y: gesture.location.y + 50)
                                    let convertedPoint = particles.convertPoint(fromView: tappedPoint)
                                    self.particles.gravity.position = convertedPoint
                                    
                                    // Increase gravity strength for faster response
                                    self.particles.gravity.strength = -80
                                    
                                    // Faster radius calculation with higher multiplier
                                    let dragRadius = calculateDynamicRadius(startTime: startTime)
                                    self.particles.gravity.region = SKRegion(radius: Float(dragRadius))
                                }
                                withAnimation(.spring(response: 0.1, dampingFraction: 0.2)) {
                                    isDragging = true
                                }
                            }
                            .onEnded { _ in
                                withAnimation(.spring(response: 0.1)) {
                                    isDragging = false
                                    self.particles.gravity.strength = 0
                                    startTime = nil
                                }
                            }
                    )
                
                
                VStack {
                    
                    Spacer()
                    
                    HStack(spacing: 40) {
                        
                        Circle()
                            .fill(Gradient(colors: [Color("GYellow"), Color("Gold")]))
                            .frame(width: 32, height: 32)
                            .overlay(
                                Circle()
                                    .stroke(.white,lineWidth: isGold ? 3 : 0)
                                    .frame(width: isGold ? 36 : 34, height: isGold ? 36 : 34)
                            )
                            .onTapGesture {
                                withAnimation(.easeIn){
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
                            .frame(width: 32, height: 32)
                            .overlay(
                                Circle()
                                    .stroke(.white,lineWidth: isSilver ? 3 : 0)
                                    .frame(width: isSilver ? 36 : 34, height: isSilver ? 36 : 34)
                            )
                            .onTapGesture {
                                withAnimation(.easeIn){
                                    isGold = false
                                    isSilver = true
                                    particles.turbStrength = 8
                                    particles.updateFieldTurbulence()
                                    
                                    Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false) { _ in
                                        particles.resetTurbulenceStrength()
                                        particles.updateParticlesColor()
                                        
                                    }
                                    
                                    particles.particleColore = .black
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
        super.init(size: CGSize(width: 500, height: 500))
        
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
        emitterNode.particleColorBlendFactor = 0.5;
        emitterNode.particleColor = .orange
        emitterNode.particleSize = CGSize(width: 30, height: 30)
        emitterNode.position = CGPoint(x: frame.midX, y: frame.midY)
        emitterNode.advanceSimulationTime(0)
        
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
        gravity.region = SKRegion(radius: 10)
        
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



