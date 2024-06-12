//
//  ToasterStyle.swift
//  ToastView
//
//  Created by Jeoffrey Thirot on 22/07/2022.
//

import SwiftUI

enum ToasterStyle {
    case error
    case warning
    case success
    case info
    case custom(color: Color, symbol: String)
}

extension ToasterStyle: CaseIterable {
    static var allCases: [ToasterStyle] { [.info, .success, .warning, .error] }
}

extension ToasterStyle: Identifiable {
    var id: String { String(describing: tint) + symbol }
    
    var tint: Color {
        switch self {
        case .error:    return Color.red
        case .warning:  return Color.orange
        case .info:     return Color.indigo
        case .success:  return Color.green
        case .custom(let color,_): return color
        }
    }

    var symbol: String {
        switch self {
        case .info:     return "info.circle.fill"
        case .warning:  return "exclamationmark.triangle.fill"
        case .success:  return "checkmark.circle.fill"
        case .error:    return "xmark.circle.fill"
        case .custom(_, let symbol): return symbol
        }
    }
    
    var shape: any Shape {
        switch self {
        case .custom:   return .capsule
        default:        return .rect(cornerRadii: RectangleCornerRadii(topLeading: 5, bottomLeading: 25, bottomTrailing: 25, topTrailing: 5))
        }
    }
}
