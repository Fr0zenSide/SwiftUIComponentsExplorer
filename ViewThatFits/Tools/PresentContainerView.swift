//
//  PresentContainerView.swift
//  CryptoBrow
//
//  Created by Jeoffrey Thirot on 31/03/2024.
//

import SwiftUI

struct PresentContainerView<ChildContent: View>: View {
    
    let childContent: ChildContent
    @Binding var isPresented: Bool
    
    init(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> ChildContent) {
        self._isPresented = isPresented
        self.childContent = content()
    }
    
    var body: some View {
        childContent
            .overlay(alignment: .topTrailing) {
                Button {
                    withAnimation(.spring(dampingFraction: 0.6, blendDuration: 0.2)) {
                        print("before isPresented: \(isPresented)")
                        isPresented.toggle()
                        print("after isPresented: \(isPresented)")
                    }
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(Color.white.opacity(0.7))
                        .padding()
                        .background(Color.black.opacity(0.2))
                        .clipShape(Circle())
                }
                .padding(.horizontal)
            }
    }
}

#Preview {
    PresentContainerView(isPresented: .constant(true)){
        Text("Super View")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(colors: [.green, .cyan, .cyan ,.indigo],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                .opacity(0.6)
            )
    }
}
