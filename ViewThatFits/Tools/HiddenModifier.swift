//
//  HiddenModifier.swift
//  MayaFit
//
//  Created by Jeoffrey Thirot on 07/04/2023.
//

import SwiftUI

struct HiddenModifier: ViewModifier {
    var isHidden: Binding<Bool>
    
    func body(content: Content) -> some View {
        if isHidden.wrappedValue {
            content
                .hidden()
        } else {
            content
        }
    }
}

extension View {
    func hidden(_ isHidden: Binding<Bool>) -> some View { self.modifier(HiddenModifier(isHidden: isHidden)) }
}
