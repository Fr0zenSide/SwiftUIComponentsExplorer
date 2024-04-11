//
//  AnimatableVector.swift
//  ViewThatFits
//
//  Created by Jeoffrey Thirot on 10/04/2024.
//  ref. from: https://gist.github.com/mecid/18a80b18cc9670eef1d8667cf8c886bd
//  and article here: https://swiftwithmajid.com/2020/06/17/the-magic-of-animatable-values-in-swiftui/
//

import SwiftUI
import enum Accelerate.vDSP

struct AnimatableVector: VectorArithmetic {
    static var zero = AnimatableVector(values: [0.0])

    static func + (lhs: AnimatableVector, rhs: AnimatableVector) -> AnimatableVector {
        let count = min(lhs.values.count, rhs.values.count)
        return AnimatableVector(values: vDSP.add(lhs.values[0..<count], rhs.values[0..<count]))
    }

    static func += (lhs: inout AnimatableVector, rhs: AnimatableVector) {
        let count = min(lhs.values.count, rhs.values.count)
        vDSP.add(lhs.values[0..<count], rhs.values[0..<count], result: &lhs.values[0..<count])
    }

    static func - (lhs: AnimatableVector, rhs: AnimatableVector) -> AnimatableVector {
        let count = min(lhs.values.count, rhs.values.count)
        return AnimatableVector(values: vDSP.subtract(lhs.values[0..<count], rhs.values[0..<count]))
    }

    static func -= (lhs: inout AnimatableVector, rhs: AnimatableVector) {
        let count = min(lhs.values.count, rhs.values.count)
        vDSP.subtract(lhs.values[0..<count], rhs.values[0..<count], result: &lhs.values[0..<count])
    }

    var values: [Double]

    mutating func scale(by rhs: Double) {
        vDSP.multiply(rhs, values, result: &values)
    }

    var magnitudeSquared: Double {
        vDSP.sum(vDSP.multiply(values, values))
    }
}
