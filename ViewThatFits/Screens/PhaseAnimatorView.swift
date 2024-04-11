//
//  PhaseAnimatorView.swift
//  ViewThatFits
//
//  Created by Jeoffrey Thirot on 10/04/2024.
//

import SwiftUI

extension PhaseAnimatorView {
    fileprivate enum TestCases: Int, Identifiable, CustomStringConvertible, CaseIterable {
        var id: Int { rawValue }
        
        case first, second, third, fourth//, fifth, sixth, seventh, eighth, ninth
        
        var description: String {
            let index = Self.allCases.firstIndex(of: self)!
            return RomanNumeralFormatter.convert(for: index + 1)
        }
    }
}

struct PhaseAnimatorView: View {
    
    @State private var selectedTestCase: TestCases = .first
    
    var body: some View {
        VStack {
            switch selectedTestCase {
            case .first:
                testCase1
            case .second:
                testCase2
            case .third:
                testCase3
            case .fourth:
                testCase4
//            case .fifth:
//                testCase5
//            case .sixth:
//                testCase6
//            case .seventh:
//                testCase7
//            case .eighth:
//                testCase8
//            case .ninth:
//                testCase9
            }
            
            Spacer()
            
            Picker("TestCase", selection: $selectedTestCase) {
                ForEach(TestCases.allCases) {
                    Text($0.description).tag($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
        }
    }
    
    
    // MARK: - tab I
    
    enum AnimationPhase: Double, CaseIterable {
        case fadingIn = 0
        case middle = 1
        case zoomingOut = 3
    }
    
    @ViewBuilder
    var testCase1: some View {
        Section("Example 1") {
            Text("Hello, world!")
                .font(.largeTitle)
                .phaseAnimator([0, 1, 3]) { view, phase in
                    view
                        .scaleEffect(phase)
                        .opacity(phase == 1 ? 1 : 0)
                }
                .padding(20)
        }
        .padding(10)
        
        Divider()
            .padding(20)
        
        Section("Example 2") {
            VStack(spacing: 50) {
                PhaseAnimator([0, 1, 3]) { value in
                    Text("Hello, world!")
                        .font(.largeTitle)
                        .scaleEffect(value)
                        .opacity(value == 1 ? 1 : 0)
                    
                    Spacer()
                        .frame(maxHeight: 40)
                    
                    Text("Goodbye, world!")
                        .font(.largeTitle)
                        .scaleEffect(3 - value)
                        .opacity(value == 1 ? 1 : 0)
                }
            }
            .padding(20)
        }
        .padding(10)
        
        Divider()
            .padding(20)
        
        Section("Example 3") {
            Text("Hello, world!")
                .font(.largeTitle)
                .phaseAnimator(AnimationPhase.allCases) { view, phase in
                    view
                        .scaleEffect(phase.rawValue)
                        .opacity(phase == .middle ? 1 : 0)
                }
                .padding(20)
        }
        .padding(10)
    }
    
    
    // MARK: - tab II
    
    enum AnimationPhase2: CaseIterable {
        case start, middle, end
    }
    
    @State private var animationStep = 0
    @State private var animationStep2 = 0
    
    @ViewBuilder
    var testCase2: some View {
        Section("Example 1") {
            Button("Tap Me!") {
                animationStep += 1
            }
            .font(.largeTitle)
            .phaseAnimator(AnimationPhase2.allCases, trigger: animationStep) { content, phase in
                content
                    .blur(radius: phase == .start ? 0 : 10)
                    .scaleEffect(phase == .middle ? 3 : 1)
            }
        }
        .padding(10)
        
        Divider()
            .padding(20)
        
        Section("Example 2") {
            Button("Tap Me!") {
                animationStep2 += 1
            }
            .font(.largeTitle)
            .phaseAnimator(AnimationPhase2.allCases, trigger: animationStep2) { content, phase in
                content
                    .blur(radius: phase == .start ? 0 : 10)
                    .scaleEffect(phase == .middle ? 3 : 1)
            } animation: { phase in
                switch phase {
                case .start, .end: .bouncy
                case .middle: .easeInOut(duration: 0.8)
                }
            }
        }
        .padding(10)
    }
    
    
    // MARK: - tab III
    
    enum AnimationPhase3: CaseIterable {
        case fadingIn, middle, zoomingOut

        var scale: Double {
            switch self {
            case .fadingIn: 0
            case .middle: 1
            case .zoomingOut: 3
            }
        }

        var opacity: Double {
            switch self {
            case .fadingIn: 0
            case .middle: 1
            case .zoomingOut: 0
            }
        }
    }
    
    @ViewBuilder
    var testCase3: some View {
        Section("Example with convinience enum API") {
            Text("Hello, world!")
                .font(.largeTitle)
                .phaseAnimator(AnimationPhase3.allCases) { content, phase in
                    content
                        .scaleEffect(phase.scale)
                        .opacity(phase.opacity)
                }
                .padding(10)
        }
        .padding(20)
    }
    
    
    // MARK: - tab IV
    
    struct Raindrop: Hashable, Equatable {
        var x: Double
        var removalDate: Date
        var speed: Double
    }

    class Storm: ObservableObject {
        var drops = Set<Raindrop>()

        func update(to date: Date) {
            drops = drops.filter { $0.removalDate > date }
            drops.insert(Raindrop(x: Double.random(in: 0...1), 
                                  removalDate: date + 1,
                                  speed: Double.random(in: 1...2)))
        }
    }
    
    @StateObject private var storm = Storm()
    let rainColor = Color(red: 0.25, green: 0.5, blue: 0.75)
    
    @ViewBuilder
    var testCase4: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                storm.update(to: timeline.date)
                
                for drop in storm.drops {
                    let age = timeline.date.distance(to: drop.removalDate)
                    let rect = CGRect(x: drop.x * size.width, 
                                      y: size.height - (size.height * age * drop.speed),
                                      width: 2,
                                      height: 10)
                    let shape = Capsule().path(in: rect)
                    context.fill(shape, with: .color(rainColor))
                }
            }
        }
        .background(.black)
        .ignoresSafeArea()
    }
    
    
    // MARK: - tab V
    
    @ViewBuilder
    var testCase5: some View {
        EmptyView()
    }
    
    @ViewBuilder
    var testCase6: some View {
        EmptyView()
    }
    
    @ViewBuilder
    var testCase7: some View {
        EmptyView()
    }
    
    @ViewBuilder
    var testCase8: some View {
        EmptyView()
    }
    
    @ViewBuilder
    var testCase9: some View {
        EmptyView()
    }
}

#Preview {
    PhaseAnimatorView()
}
