//
//  MainButtonStyle.swift
//  CryptoBrow
//
//  Created by Jeoffrey Thirot on 15/03/2024.
//

import SwiftUI

struct MainButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    
    let textColor: Color
    let backgroundStyle: AnyShapeStyle // Don't use `any ShapeStyle` to chain modifier
    let borderColor: Color
    let borderWidth: CGFloat
    
    init(textColor: Color = .white,
         backgroundGradient: any ShapeStyle = Color.blue.gradient,
         borderColor: Color = .clear,
         borderWidth: CGFloat = 1) {
        self.textColor = textColor
        self.backgroundStyle = AnyShapeStyle(backgroundGradient)
        self.borderColor = borderColor
        self.borderWidth = borderWidth
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 74)
            .font(.title)
            .background(backgroundStyle)
            .foregroundStyle(textColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(alignment: .center, content: {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: borderWidth)
            })
            .contentShape(Rectangle()) // Usefull if you want to set the background to clear and having still all the button touchable
            .opacity(isEnabled ? 1.0 : 0.7)
            .opacity(configuration.isPressed ? 0.5 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: UUID())
    }
}

extension ButtonStyle where Self == MainButtonStyle {
    static var main: Self {
        return .init()
    }
    
    static var secondary: Self {
        return .init(
            textColor: Color.black.opacity(0.8),
            backgroundGradient: Color.clear,
            borderColor: Color.black.opacity(0.6)
        )
    }
}

#Preview {
    VStack {
        Button("Title") {
            
        }
        .buttonStyle(.main)
        
        Button("Title") {
            
        }
        .buttonStyle(.secondary)
    }
    .padding()
}
