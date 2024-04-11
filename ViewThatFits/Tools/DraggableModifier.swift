//
//  DraggableModifier.swift
//  CryptoBrow
//
//  Created by Jeoffrey Thirot on 09/04/2024.
//

import SwiftUI

struct DraggableModifier: ViewModifier {
    
    @State private var offset = CGSize.zero
    @Binding var velocityToHide: Bool
    
    @State private var lastScaleValue: CGFloat = 1.0
    @State private var scale: CGFloat = 1.0
    
    init(_ stopToDisplay: Binding<Bool>) {
        self._velocityToHide = stopToDisplay
    }
    
    func body(content: Content) -> some View {
        content
//            .cornerRadius(20)
//            .shadow(color: .gray, radius: 10, x: 8, y: 15)
//            .padding()
            .scaleEffect(CGSize(width: scale, height: scale))
            .rotationEffect(.degrees(Double(offset.height / 20)))
            .offset(x: 0, y: offset.height)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        offset = gesture.translation
//                        print("v:", gesture.velocity)
//                        print("l:", gesture.predictedEndLocation)
//                        print("t:", gesture.predictedEndTranslation)
                    }
                    .onEnded { gesture in
//                        withAnimation(.easeIn(duration: 0.3)) {
                        withAnimation(.spring(dampingFraction: 0.6, blendDuration: 0.2)) {
                            offset = .zero
                            if abs(gesture.velocity.height) > 1000 {
                                velocityToHide = false
                            }
                        }
                    }
            )
            .gesture(
                MagnificationGesture()
                    .onChanged { val in
                        let delta = val / self.lastScaleValue
                        self.lastScaleValue = val
                        let newScale = self.scale * delta

                        //... anything else e.g. clamping the newScale
                        self.scale = newScale
                    }.onEnded { val in
                        // without this the next gesture will be broken
                        self.lastScaleValue = 1.0
                        withAnimation(.spring(dampingFraction: 0.6, blendDuration: 0.2)) {
                            self.scale = 1.0
                        }
                    }
            )
    }
}

extension View {
    func closeDraggable(stopToDisplay: Binding<Bool>) -> some View {
        self.modifier(DraggableModifier(stopToDisplay))
    }
}

#Preview {
    Image("background")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .cornerRadius(20)
        .shadow(color: .gray, radius: 10, x: 8, y: 15)
        .padding()
        .closeDraggable(stopToDisplay: .constant(false))
}
