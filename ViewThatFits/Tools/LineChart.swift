//
//  LineChart.swift
//  ViewThatFits
//
//  Created by Jeoffrey Thirot on 10/04/2024.
//

import SwiftUI

struct LineChart: Shape {
    var vector: AnimatableVector

    var animatableData: AnimatableVector {
        get { vector }
        set { vector = newValue }
    }

    func path(in rect: CGRect) -> Path {
        Path { path in
            let xStep = rect.width / CGFloat(vector.values.count)
            var currentX: CGFloat = xStep
            path.move(to: .zero)

            vector.values.forEach {
                path.addLine(to: CGPoint(x: currentX, y: CGFloat($0)))
                currentX += xStep
            }
        }
    }
}

#Preview {
    LineChart(vector: AnimatableVector(values: [50, 100, 75, 100]))
        .stroke(Color.indigo)
        .animation(Animation.default.repeatForever(), value: UUID())
}
