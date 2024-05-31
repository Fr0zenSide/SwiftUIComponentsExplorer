//
//  BarProgressStyle.swift
//  CryptoBrow
//
//  Created by Jeoffrey Thirot on 05/04/2024.
//

import SwiftUI

struct BarProgressStyle: ProgressViewStyle {
 
    var height: Double
    var color: AnyShapeStyle
    var labelFontStyle: Font
    
    init(height: Double = 20.0, 
         color: any ShapeStyle = Color.purple,
         labelFontStyle: Font = .body) {
        
        self.height = height
        self.color = AnyShapeStyle(color)
        self.labelFontStyle = labelFontStyle
    }
 
    func makeBody(configuration: Configuration) -> some View {
 
        let progress = configuration.fractionCompleted ?? 0.0
 
        GeometryReader { geometry in
 
            VStack(alignment: .leading) {
 
                configuration.label
                    .font(labelFontStyle)
 
                RoundedRectangle(cornerRadius: 10.0)
                    .fill(Color(uiColor: .systemGray5))
                    .frame(height: height)
                    .frame(width: geometry.size.width)
                    .overlay(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10.0)
                            .fill(color)
                            .frame(width: geometry.size.width * progress)
                            .overlay {
                                if let currentValueLabel = configuration.currentValueLabel {
 
                                    currentValueLabel
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                            }
                    }
 
            }
 
        }
    }
}

extension ProgressViewStyle where Self == BarProgressStyle {
    static func bar(height: Double = 20.0, color: any ShapeStyle = Color.purple.gradient) -> Self {
        return .init(height: height, color: color)
    }
}

#Preview {
    ProgressView(value: 0.3, label: { Text("Processing...") }, currentValueLabel: { Text("30%") })
        .progressViewStyle(.bar(height: 100))
        .padding()
}
