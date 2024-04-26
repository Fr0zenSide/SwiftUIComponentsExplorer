//
//  CapsuleProgressView.swift
//  ViewThatFits
//
//  Created by Jeoffrey Thirot on 26/04/2024.
//

import SwiftUI

struct CapsuleProgressView: View, Animatable {
    var progress: Double
    private let delay = 0.2
    
    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }
    
    var body: some View {
        Capsule()
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

#Preview {
    CapsuleProgressView(progress: 0.5)
        .padding()
}
