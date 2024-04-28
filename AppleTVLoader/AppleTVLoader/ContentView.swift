//
//  ContentView.swift
//  AppleTVLoader
//
//  Created by Toni on 22.01.2024.
//

import SwiftUI




extension View {
    func iconBox() -> some View {
        self
            .font(.title)
            .foregroundStyle(.white)
            .padding(8)
            .cornerRadius(10)
        
    }
}


struct Rotation: LayoutValueKey {
    static let defaultValue: Binding<Angle>? = nil
}

struct circularLayout: Layout {
    
    var radius: CGFloat
    var rotation: Angle
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        
        let maxSize = subviews.map { $0.sizeThatFits(proposal) }.reduce(CGSize.zero) {
            
            return CGSize(width: max($0.width, $1.width), height: max($0.height, $1.height))
            
        }
        
        return CGSize(width: (maxSize.width / 2 + radius) * 2,
                      height: (maxSize.height / 2 + radius) * 2)
    }
    
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ())
    {
        let angleStep = (Angle.degrees(360).radians / Double(subviews.count))
        
        for (index, subview) in subviews.enumerated() {
            let angle = angleStep * CGFloat(index) + rotation.radians
            
            // Find a vector with an appropriate size and rotation.
            var point = CGPoint(x: 0, y: -radius).applying(CGAffineTransform(rotationAngle: angle))
            
            // Shift the vector to the middle of the region.
            point.x += bounds.midX
            point.y += bounds.midY
            
            // Place the subview.
            subview.place(at: point, anchor: .center, proposal: .unspecified)
            
            
            DispatchQueue.main.async {
                subview[Rotation.self]?.wrappedValue = .radians(angle)
            }
        }
    }
}



struct ContentView: View {
    
    
    @State private var elementsNumber: Int = 8
    @State private var isVertical = true
    @State private var isHorizontal = false
    @State private var rotations: [Angle] = Array<Angle>(repeating: .zero, count: 8)
    @State private var numb : Int = 0
    
    @State private var activeTab: Tab = .vstack
    @State private var allTabs: [AnimatedTab] = Tab.allCases.compactMap { tab -> AnimatedTab? in return .init(tab:tab)}
    
    
    var body: some View {
        
        let layout = isVertical ? AnyLayout(VStackLayout(spacing: -14)) : isHorizontal ? AnyLayout(HStackLayout(spacing: 16)) : AnyLayout(circularLayout(radius: 60, rotation: .degrees(0)))
        
        
        
        
        
        ZStack {
            Color.black.ignoresSafeArea()
            
            ZStack {
                VStack {
                    
                    Spacer()
                    
                    layout {
                        ForEach(0..<elementsNumber, id: \.self) { i in
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.white.opacity((numb == i) ? 1 : 0.1))
                                .frame(width: 30, height: 60)
                                .rotationEffect(isVertical ? .degrees(90) : isHorizontal ? .zero : rotations[i])
                                .layoutValue(key: Rotation.self, value: $rotations[i])
                            
                            
                        }
                        
                    }
                    .onAppear {
                        loadAnimation()
                    }
                    
                    Spacer()
                    
                    HStack (spacing: 40) {
                        ForEach($allTabs) { $animatedTab in
                            let atab = animatedTab.tab
                            
                            Image(systemName: atab.rawValue)
                                .font(.title)
                                .symbolEffect(.bounce.up.byLayer, value: animatedTab.isAnimating)
                                .foregroundStyle(activeTab == atab ? Color.white.opacity(0.6) : Color.gray.opacity(0.4))
                                .contentShape(.rect)
                            //                                .onTapGesture {
                            //
                            //
                            //                        }
                                .onTapGesture {
                                    
                                    withAnimation(.default, completionCriteria: .logicallyComplete, {
                                        activeTab = atab
                                        animatedTab.isAnimating = true
                                    }, completion: {
                                        
                                        var transaction = Transaction()
                                        transaction.disablesAnimations = true
                                        withTransaction(transaction) {
                                            animatedTab.isAnimating = nil
                                        }
                                    }
                                                  
                                                  
                                    )
                                    withAnimation {
                                        
                                        if atab == Tab.vstack {
                                            
                                            isVertical = true
                                            isHorizontal = false
                                        }
                                        
                                        if atab == Tab.hstack {
                                            
                                            isVertical = false
                                            isHorizontal = true
                                            
                                        } else if atab == Tab.circle {
                                            isVertical = false
                                            isHorizontal = false
                                        }
                                        
                                    }
                                }
                        }
                        
                        
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 40)
                    .background(.ultraThinMaterial.opacity(0.2))
                    .cornerRadius(20)
                    
                }
                
            }
        }
    }
    
    
    func loadAnimation() {
        DispatchQueue.main.async {
            Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) { _ in
                withAnimation() {
                    numb = (numb + 1) % (elementsNumber + 1)
                    
                }
            }
        }
    }
    
}

#Preview {
    ContentView()
}



