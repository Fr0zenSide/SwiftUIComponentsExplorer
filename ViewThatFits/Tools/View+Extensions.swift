//
//  View+Extensions.swift
//  ViewThatFits
//
//  Created by Jeoffrey Thirot on 10/04/2024.
//

import SwiftUI

// Create an immediate animation.
extension View {
    func animateOnAppear(using animation: Animation = .easeInOut(duration: 1), _ modifyProperties: @escaping () -> Void) -> some View {
        onAppear {
            withAnimation(animation) {
                modifyProperties()
            }
        }
    }
}

// Create an immediate, looping animation
extension View {
    func animateForeverOnAppear(using animation: Animation = .easeInOut(duration: 1), autoreverses: Bool = false, _ modifyProperties: @escaping () -> Void) -> some View {
        let repeated = animation.repeatForever(autoreverses: autoreverses)

        return onAppear {
            withAnimation(repeated) {
                modifyProperties()
            }
        }
    }
}
