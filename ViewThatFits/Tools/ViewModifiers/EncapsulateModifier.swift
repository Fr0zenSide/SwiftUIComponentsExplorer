//
//  EncapsulateModifier.swift
//  ViewThatFits
//
//  Created by Jeoffrey Thirot on 26/04/2024.
//

import SwiftUI

struct EncapsulateModifier<Background: View, Overlay: View>: ViewModifier {
    
    let background: Background?
    let overlay: Overlay?
    
    init(_ background: (() -> Background)? = nil,
         overlay: (() -> Overlay)? = nil) {
        self.background = background?()
        self.overlay = overlay?()
    }
    
    init(bg background: @escaping (() -> Background)) {
        self.init(background, overlay: nil)
    }
    
    init(ovlay overlay: (() -> Overlay)? = nil) {
        self.init(nil, overlay: overlay)
    }
    
    func body(content: Content) -> some View {
        ZStack {
            background
            content
            overlay
        }
    }
}

extension View {
    func encapsulate<BgV: View, OverlayV: View>(in background: (() -> BgV)? = nil, with overlay: (() -> OverlayV)? = nil) -> some View {
        self.modifier(EncapsulateModifier<BgV, OverlayV>(background, overlay: overlay))
    }
    
    func encapsulate<BgV: View>(in background: @escaping (() -> BgV)) -> some View {
        self.modifier(EncapsulateModifier<BgV, AnyView>(bg: background))
    }
    
    func encapsulate<OverlayV: View>(with overlay: @escaping (() -> OverlayV)) -> some View {
        self.modifier(EncapsulateModifier<AnyView, OverlayV>(ovlay: overlay))
    }
}

#Preview {
    VStack {
        Text("Titou")
            .encapsulate(in: {
                Capsule()
                    .stroke(Color.blue.gradient, lineWidth: 1.0)
            }, with: {
                EmptyView()
            })
            .frame(maxHeight: 80)
            .padding()
        
        Text("Titou")
            .encapsulate(in: {
                Capsule()
                    .stroke(Color.blue.gradient, lineWidth: 1.0)
            })
            .frame(maxHeight: 80)
            .padding()
        
        Text("Titou")
            .encapsulate(in: {
                Capsule()
                    .foregroundStyle(.blue.gradient.opacity(0.25))
                    .background(
                        .background
                            .shadow(.drop(color: .primary.opacity(0.06), radius: 5, x: 5, y: 5))
                            .shadow(.drop(color: .primary.opacity(0.06), radius: 8, x: -5, y: -5)),
                        in: .capsule
                    )
                    .contentShape(.capsule)
            })
            .frame(maxHeight: 80)
            .padding()
        
        Text("Titou")
            .encapsulate(with: {
                Capsule()
                    .stroke(.blue.gradient.opacity(0.3), lineWidth: 2)
            })
            .frame(maxHeight: 80)
            .padding()
        Spacer()
    }
}
