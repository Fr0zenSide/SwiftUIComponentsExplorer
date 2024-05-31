//
//  ToastModel.swift
//  ToastView
//
//  Created by Jeoffrey Thirot on 22/07/2022.
//

import Foundation

struct ToastModel: Equatable {
    var type: ToastStyle
    var title: String
    var message: String
    var duration: Double = 3
}
