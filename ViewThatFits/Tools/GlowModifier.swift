//
//  GlowModifier.swift
//  ViewThatFits
//
//  Created by Jeoffrey Thirot on 26/04/2024.
//

import SwiftUI

// MARK: - Method to add glow effect with a shape
extension View where Self: Shape {
    func glow(fill: some ShapeStyle,
              lineWidth: Double,
              blurRadius: Double = 8.0,
              lineCap: CGLineCap = .round) -> some View {
        self
            .stroke(style: StrokeStyle(lineWidth: lineWidth / 2, lineCap: lineCap))
            .fill(fill)
            .overlay {
                self
                    .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: lineCap))
                    .fill(fill)
                    .blur(radius: blurRadius)
            }
            .overlay {
                self
                    .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: lineCap))
                    .fill(fill)
                    .blur(radius: blurRadius / 2)
            }
    }
}

// MARK: - Helper to get a color gradient
extension ShapeStyle where Self == AngularGradient {
  static var palette: some ShapeStyle {
    .angularGradient(
      stops: [
        .init(color: .blue, location: 0.0),
        .init(color: .purple, location: 0.2),
        .init(color: .red, location: 0.4),
        .init(color: .mint, location: 0.5),
        .init(color: .indigo, location: 0.7),
        .init(color: .pink, location: 0.9),
        .init(color: .blue, location: 1.0),
      ],
      center: .center,
      startAngle: Angle(radians: .zero),
      endAngle: Angle(radians: .pi * 2)
    )
  }
}

// MARK: - Shape View with glow can be animated with Animatable implementation
struct ShapeProgressView: View, Animatable {
    var animatableData: Double {
      get { progress }
      set { progress = newValue }
    }
    
    private let delay: Double = 0.2
    private let myShape: AnyShape
    private var progress: Double
    
    init(around myShape: some Shape = Capsule(), progress: Double) {
        self.myShape = AnyShape(myShape)
        self.progress = progress
    }
    
    var body: some View {
        myShape
            .trim(from: {
                if progress > 1 - delay {
                    2 * progress - 1.0
                } else if progress > delay {
                    progress - delay
                } else {
                    .zero
                }
            }(),
                  to: progress)
            .glow(fill: .palette, lineWidth: 4.0)
    }
}

// MARK: - View with two Shape glow to have a continuous animation
struct GlowShapeView: View {
    
    @State private var progress1: Double = 0.0
    @State private var progress2: Double = 0.0
    
    private let myShape: AnyShape
    
    init(around myShape: some Shape = Capsule()) {
        self.myShape = AnyShape(myShape)
    }

    var body: some View {
        ZStack {
            ShapeProgressView(around: myShape, progress: progress1)
            ShapeProgressView(around: myShape, progress: progress2)
                .rotationEffect(.degrees(180.0))
        }
        .compositingGroup()
//        .padding()
//        .drawingGroup()
        .onAppear() {
            withAnimation(
              .linear(duration: 2.0)
              .repeatForever(autoreverses: false)
            ) {
                progress1 = 1.0
            }
            withAnimation(
              .linear(duration: 2.0)
              .repeatForever(autoreverses: false)
              .delay(1.0)
            ) {
                progress2 = 1.0
            }
        }
    }
}

// MARK: - Modifier to add easily a Glow overlay with animation (overlay break animation => ZStack)
struct GlowModifier: ViewModifier {
    private let myShape: AnyShape
    
    init(around myShape: some Shape = Capsule()) {
        self.myShape = AnyShape(myShape)
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            GlowShapeView(around: myShape)
        }
    }
}

// MARK: - Helper to use the Modifier
extension View {
    func glowing(around shape: some Shape = RoundedRectangle(cornerRadius: 12)) -> some View {
        self.modifier(GlowModifier(around: shape))
    }
}

#Preview {
    VStack(spacing: 20) {
        Capsule()
            .glow(fill: .palette, lineWidth: 4.0)
            
        
        Text("Text with border")
            .glowing()
        
        
        Button("Text with border") {
            print("click on it")
        }
        .background(content: {
            RoundedRectangle(cornerRadius: 12).stroke(.blue, lineWidth: 1.0)
        })
        .frame(maxHeight: 44)
        .glowing()
    }
    .padding()
}
