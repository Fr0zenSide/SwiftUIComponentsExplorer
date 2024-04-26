//
//  LoadingButtonStyle.swift
//  ViewThatFits
//
//  Created by Jeoffrey Thirot on 26/04/2024.
//

import SwiftUI

struct LoadingButtonStyle: ButtonStyle {
    
    @Environment(\.isEnabled) var isEnabled
    
    @State var active: Bool = true
    @Binding var isLoading: Bool
    
    @State private var progress: Double = 0.0
    private let delay: Double = 0.2
    
    private let textColor: Color
    private let backgroundStyle: AnyShapeStyle // Don't use `any ShapeStyle` to chain modifier
    private let borderColor: Color
    private let borderWidth: CGFloat
    private let backgroundShape: AnyShape
    private let maxHeight: Double
    
    init(isLoading: Binding<Bool>,
         textColor: Color = .white,
         maxHeight: Double = 74.0,
         backgroundGradient: any ShapeStyle = Color.blue.gradient,
         borderColor: Color = .clear,
         borderWidth: CGFloat = 1,
         backgroundShape: any Shape = Capsule()) {
        self._isLoading     = isLoading
        self.textColor      = textColor
        self.maxHeight      = maxHeight
        self.borderColor    = borderColor
        self.borderWidth    = borderWidth
        self.backgroundStyle = AnyShapeStyle(backgroundGradient)
        self.backgroundShape = AnyShape(backgroundShape)
    }
    
    func makeBody(configuration: Configuration) -> some View {
        LabeledContent {
            Image(systemName: "paperplane.circle")
//                .font(.largeTitle)
                .font(.custom("SFCompact-Regular", size: maxHeight * 0.64, relativeTo: .largeTitle)) // "SFPro-Regular"
                .foregroundStyle(textColor)
                .padding(.trailing)
                .scaleEffect(configuration.isPressed ? 1.4 : 1.0)
        } label: {
            defaultLabelSetup(configuration: configuration)
                .opacity(isEnabled ? 1.0 : 0.7)
                .opacity(configuration.isPressed ? 0.5 : 1.0)
                .padding(.trailing, 0)
        }
        .frame(maxWidth: .infinity, maxHeight: maxHeight)
//        .font(.title)
        .font(.custom("SFCompact-Regular", size: maxHeight * 0.5, relativeTo: .title))
        .background {
            backgroundShape
                .fill(backgroundStyle)
                .opacity(configuration.isPressed ? 0.8 : 1.0)
        }
        .foregroundStyle(textColor)
        .if(isLoading, transform: { view in
            view
                .glowing(around: backgroundShape)
        })
//        .clipShape(backgroundShape)
        .overlay(alignment: .center, content: {
            backgroundShape
                .stroke(borderColor, lineWidth: borderWidth)
                .opacity(configuration.isPressed ? 0.8 : 1.0)
        })
        .contentShape(Rectangle()) // Usefull if you want to set the background to clear and having still all the button touchable
        .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: UUID())
    }
    
    @ViewBuilder
    func defaultLabelSetup(configuration: Configuration) -> some View {
        configuration.label
//            .disabled(isLoading || isEnabled)
            .padding()
            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            .layoutPriority(0.5)
    }
}

extension ButtonStyle where Self == LoadingButtonStyle {
    static func loading(_ isLoading: Binding<Bool> = .constant(false), backgroundShape: any Shape = RoundedRectangle(cornerRadius: 12), maxHeight: Double = 44.0) -> Self {
        return .init(isLoading: isLoading, maxHeight: maxHeight, backgroundShape: backgroundShape)
    }
    
    static func loadingSec(_ isLoading: Binding<Bool> = .constant(false), backgroundShape: any Shape = RoundedRectangle(cornerRadius: 12), maxHeight: Double = 44.0) -> Self {
        return .init(
            isLoading: isLoading,
            textColor: Color.black.opacity(0.8),
            maxHeight: maxHeight,
            backgroundGradient: Color.clear,
            borderColor: Color.black.opacity(0.6),
            backgroundShape: backgroundShape
        )
    }
}

#Preview {
    VStack {
        Button("Title") {
            
        }
        .buttonStyle(.loading())
        
        Button("Title is loading can be too long for that") {
            
        }
        .buttonStyle(.loading(.constant(true), maxHeight: 54))
        
        Button("Title") {
            
        }
        .buttonStyle(.loadingSec())
        
        Spacer()
    }
    .padding()
}
