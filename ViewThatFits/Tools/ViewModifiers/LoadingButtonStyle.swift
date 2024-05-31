//
//  LoadingButtonStyle.swift
//  ViewThatFits
//
//  Created by Jeoffrey Thirot on 26/04/2024.
//

import SwiftUI

enum AccessoryLoadingButtonStyle {
    case next, done, progress, none
    case icon(_ systemName: String)
}

struct LoadingButtonStyle: ButtonStyle {
    
    @Environment(\.isEnabled) var isEnabled
    
    @State var active: Bool = true
    @Binding var isLoading: Bool
    
    @State private var progress: Double = 0.0
    private let delay: Double = 0.2
    
    private let accessory: AccessoryLoadingButtonStyle
    private let textColor: Color
    private let labelFont: Font
    private let backgroundStyle: AnyShapeStyle // Don't use `any ShapeStyle` to chain modifier
    private let borderColor: Color
    private let borderWidth: CGFloat
    private let backgroundShape: AnyShape
    private let maxHeight: Double
    
    init(isLoading: Binding<Bool>,
         accessory: AccessoryLoadingButtonStyle = .next,
         textColor: Color = .white,
         font: Font = .title,
         maxHeight: Double = 74.0,
         backgroundGradient: any ShapeStyle = Color.blue.gradient,
         borderColor: Color = .clear,
         borderWidth: CGFloat = 1,
         backgroundShape: any Shape = Capsule()) {
        self._isLoading     = isLoading
        self.accessory      = accessory
        self.textColor      = textColor
        self.labelFont      = font
        self.maxHeight      = maxHeight
        self.borderColor    = borderColor
        self.borderWidth    = borderWidth
        self.backgroundStyle = AnyShapeStyle(backgroundGradient)
        self.backgroundShape = AnyShape(backgroundShape)
    }
    
    func makeBody(configuration: Configuration) -> some View {
        LabeledContent {
            accessoryView(accessory)
                .padding(.trailing)
                .scaleEffect(configuration.isPressed ? 1.4 : 1.0)

//            Image(systemName: "paperplane.circle")
////                .font(.largeTitle)
////                .font(.custom("SFCompact-Regular", size: maxHeight * 0.64, relativeTo: .largeTitle)) // "SFPro-Regular"
//                .font(labelFont)
//                .foregroundStyle(textColor)
//                .padding(.trailing)
//                .scaleEffect(configuration.isPressed ? 1.4 : 1.0)
        } label: {
            defaultLabelSetup(configuration: configuration)
                .opacity(isEnabled ? 1.0 : 0.7)
                .opacity(configuration.isPressed ? 0.5 : 1.0)
                .padding(.trailing, 0)
        }
        .frame(maxWidth: .infinity, maxHeight: maxHeight)
//        .font(.title)
//        .font(.custom("SFCompact-Regular", size: maxHeight * 0.5, relativeTo: .title))
        .font(labelFont)
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
    
    @ViewBuilder
    func accessoryView(_ setup: AccessoryLoadingButtonStyle) -> some View {
        switch accessory {
        case .next:
            Image(systemName: "arrow.right.circle")
                .font(labelFont)
                .foregroundStyle(textColor)
        case .done:
            Image(systemName: "checkmark.circle")
                .font(labelFont)
                .foregroundStyle(textColor)
        case .progress:
            ProgressView(value: 0.3, label: { Text("Processing...") }, currentValueLabel: { Text("30%") })
                .progressViewStyle(.bar(height: 100))
        case .none:
            EmptyView()
        case .icon(let systemName):
            Image(systemName: systemName)
//                .font(.largeTitle)
//                .font(.custom("SFCompact-Regular", size: maxHeight * 0.64, relativeTo: .largeTitle)) // "SFPro-Regular"
                .font(labelFont)
                .foregroundStyle(textColor)
                
        }
    }
}

extension ButtonStyle where Self == LoadingButtonStyle {
    static func loading(_ isLoading: Binding<Bool> = .constant(false),
                        accessory: AccessoryLoadingButtonStyle = .icon("paperplane.circle"),
                        backgroundGradient: any ShapeStyle = Color.blue.gradient,
                        backgroundShape: any Shape = RoundedRectangle(cornerRadius: 12),
                        maxHeight: Double = 44.0,
                        font: Font = .title) -> Self {
        return .init(isLoading: isLoading, 
                     accessory: accessory,
                     font: font,
                     maxHeight: maxHeight,
                     backgroundGradient: backgroundGradient,
                     backgroundShape: backgroundShape)
    }
    
    static func loadingSec(_ isLoading: Binding<Bool> = .constant(false),
                           accessory: AccessoryLoadingButtonStyle = .icon("checkmark.circle.fill"),
                           backgroundGradient: any ShapeStyle = Color.clear,
                           backgroundShape: any Shape = RoundedRectangle(cornerRadius: 12),
                           maxHeight: Double = 44.0,
                           font: Font = .title) -> Self {
        return .init(
            isLoading: isLoading,
            accessory: accessory,
            textColor: Color.black.opacity(0.8),
            font: font,
            maxHeight: maxHeight,
            backgroundGradient: backgroundGradient,
            borderColor: Color.black.opacity(0.6),
            backgroundShape: backgroundShape)
    }
}

#Preview {
    VStack(spacing: 24) {
        
        Spacer()
        
        Button("Regular style") {
            
        }
        .buttonStyle(.loading())
        
        var loading: Binding<Bool> = .variable(true)
        Button("Title is loading can be too long for that") {
            loading.wrappedValue.toggle()
        }
        .buttonStyle(.loading(loading, maxHeight: 74, font: .title2))
        .frame(height: 74)
        
        Button("Regular secondary") {
            
        }
        .buttonStyle(.loadingSec())
        
        Button("Capsule") {
            loading.wrappedValue.toggle()
        }
        .buttonStyle(.loadingSec(loading, backgroundShape: Capsule()))
        .frame(height: 44)
        
        Button("Progress") {
            loading.wrappedValue.toggle()
        }
        .buttonStyle(.loading(loading, accessory: .progress, maxHeight: 44, font: .title2))
        .frame(height: 44)
        .clipped()
        
        
        Button("No accessory") {}
            .buttonStyle(.loading(accessory: .none,
                                  backgroundGradient: .blue.gradient.opacity(0.5)
                .shadow(.drop(color: .primary.opacity(0.6), radius: 5, x: 5, y: 5)), 
                                  maxHeight: 44, font: .title2))
            .frame(height: 44)
        
        Button("Next accessory") {}
            .buttonStyle(.loading(accessory: .next,
                                  maxHeight: 44, font: .title2))
            .frame(height: 44)
        
        Button("Done accessory") {}
            .buttonStyle(.loading(accessory: .done,
                                  maxHeight: 44, font: .title2))
            .frame(height: 44)
        
        Spacer()
    }
    .padding()
}
