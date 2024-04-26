//
//  CapsuleProgress2View.swift
//  ViewThatFits
//
//  Created by Jeoffrey Thirot on 26/04/2024.
//  ref. https://uvolchyk.medium.com/making-things-glow-and-shine-with-swiftui-80448c560f88
//

import SwiftUI

struct CapsuleProgress2View: View {
    @State private var progress1: Double = 0.0
    @State private var progress2: Double = 0.0
    
    var body: some View {
        ZStack {
            CapsuleProgressView(progress: progress1)
            CapsuleProgressView(progress: progress2)
                .rotationEffect(.degrees(180.0))
        }
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

#Preview {
    CapsuleProgress2View()
        .padding()
}
