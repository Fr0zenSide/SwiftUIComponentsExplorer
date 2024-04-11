//
//  AnimationView.swift
//  ViewThatFits
//
//  Created by Jeoffrey Thirot on 10/04/2024.
//

import SwiftUI

extension AnimationView {
    fileprivate enum TestCases: Int, Identifiable, CustomStringConvertible, CaseIterable {
        var id: Int { rawValue }
        
        case first, second, third, fourth, fifth//, sixth, seventh, eighth, ninth
        
        var description: String {
            let index = Self.allCases.firstIndex(of: self)!
            return RomanNumeralFormatter.convert(for: index + 1)
        }
    }
}

struct AnimationView: View {
    
    @State private var selectedTestCase: TestCases = .first
    
    init() {
//        AnimatableVector.zero = AnimatableVector(values: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0])
    }
    
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
            case .fifth:
                testCase5
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
    
    @Namespace private var animation
    @State private var isFlipped = false
    @State private var isFlipped2 = false
    
    @State private var isZoomed = false
    
    var frame: Double {
        isZoomed ? 300 : 44
    }
    
    @ViewBuilder
    var testCase1: some View {
        VStack {
            Section("Example 1") {
                VStack {
                    if isFlipped {
                        Circle()
                            .fill(.red)
                            .frame(width: 44, height: 44)
                        Text("Taylor Swift – 1989")
                            .font(.headline)
                    } else {
                        Text("Taylor Swift – 1989")
                            .font(.headline)
                        Circle()
                            .fill(.blue)
                            .frame(width: 44, height: 44)
                    }
                }
                .onTapGesture {
                    withAnimation {
                        isFlipped.toggle()
                    }
                }
            }
            
            Divider()
                .padding()
            
            Section("Example 2") {
                VStack {
                    if isFlipped2 {
                        Circle()
                            .fill(.red)
                            .frame(width: 44, height: 44)
                            .matchedGeometryEffect(id: "Shape", in: animation)
                        Text("Taylor Swift – 1989")
                            .font(.headline)
                            .matchedGeometryEffect(id: "AlbumTitle", in: animation)
                    } else {
                        Text("Taylor Swift – 1989")
                            .font(.headline)
                            .matchedGeometryEffect(id: "AlbumTitle", in: animation)
                        Circle()
                            .fill(.blue)
                            .frame(width: 44, height: 44)
                            .matchedGeometryEffect(id: "Shape", in: animation)
                    }
                }
                .onTapGesture {
                    withAnimation {
                        isFlipped2.toggle()
                    }
                }
            }
            
            Divider()
                .padding()
            
            Section("Example 3") {
                VStack {
                    Spacer()
                    
                    VStack {
                        HStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.blue)
                                .frame(width: frame, height: frame)
                                .padding(.top, isZoomed ? 20 : 0)
                            
                            if isZoomed == false {
                                Text("Taylor Swift – 1989")
                                    .matchedGeometryEffect(id: "AlbumTitle2", in: animation)
                                    .font(.headline)
                                Spacer()
                            }
                        }
                        
                        if isZoomed == true {
                            Text("Taylor Swift – 1989")
                                .matchedGeometryEffect(id: "AlbumTitle2", in: animation)
                                .font(.headline)
                                .padding(.bottom, 60)
                            Spacer()
                        }
                    }
                    .onTapGesture {
                        withAnimation(.spring()) {
                            isZoomed.toggle()
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 370)
                    .background(Color(white: 0.9))
                    .foregroundStyle(.black)
                }
            }
        }
        .padding()
    }
    
    @State private var scaleUp = false
    @State private var fadeOut = false
    
    @State private var scaleUp2 = false
    @State private var fadeOut2 = false

    @ViewBuilder
    var testCase2: some View {
        VStack {
            Section("Example 1") {
                Button("Tap Me!") {
                    withAnimation {
                        scaleUp = true
                    } completion: {
                        withAnimation {
                            fadeOut = true
                        }
                    }
                }
                .scaleEffect(scaleUp ? 3 : 1)
                .opacity(fadeOut ? 0 : 1)
            }
            
            Divider()
                .padding()
            
            Section("Example 2") {
                Button("Tap Me!") {
                    withAnimation(.bouncy, completionCriteria: .removed) {
                        scaleUp2 = true
                    } completion: {
                        withAnimation {
                            fadeOut2 = true
                        }
                    }
                }
                .scaleEffect(scaleUp2 ? 3 : 1)
                .opacity(fadeOut2 ? 0 : 1)
            }
        }
        .padding()
    }
    
    struct OffsetXEffectModifier: ViewModifier, Animatable {
        typealias T = CGFloat
        
        
        var targetValue: T
        var onCompletion: (() -> Void)?
        
        init(value: T, onCompletion: (() -> Void)? = nil) {
            self.targetValue = value
            self.animatableData = value
            self.onCompletion = onCompletion
        }
        
        var animatableData: CGFloat {
            didSet {
                checkIfFinished()
            }
        }
        
        func checkIfFinished() -> () {
            // This method is called for every intermediate value update
            if let onCompletion = onCompletion, animatableData == targetValue {
                DispatchQueue.main.async {
                    onCompletion()
                }
            }
        }
        
        func body(content: Content) -> some View {
            content.offset(x: targetValue)
        }
    }
    
    @State var offsetX: CGFloat = .zero
    
    @ViewBuilder
    var testCase3: some View {
        ZStack {
            Text("Hello")
                .border(.red, width: 1)
                .modifier(
                    OffsetXEffectModifier(value: offsetX, onCompletion: {
                        print("Completed")
                    })
                )
                .animateOnAppear(using: .easeOut(duration: 3.5)) {
                    offsetX = 100
                }
        }
        .frame(width: 100, height: 100, alignment: .bottomLeading)
    }
    
    
    @State private var vector: AnimatableVector = .zero
    
    @ViewBuilder
    var testCase4: some View {
        VStack {
            
            LineChart(vector: vector)
                .stroke(Color.indigo.gradient)
                .animation(Animation.default.repeatForever(autoreverses: true), value: vector)
                .onAppear {
                    self.vector = AnimatableVector(values: [50, 100, 75, 100, 25, 55])
                }
            
            Button("Randomize") {
                let values = (0...5).map { _ in Double(Int.random(in: 0...100)) }
                self.vector = AnimatableVector(values: values)
                print("new Values: \(values)")
            }
            .padding()
            .contentShape(Rectangle())
            .frame(maxWidth: .infinity)
        }
        .background(Color.gray.opacity(0.1).gradient)
        .padding()
    }
    
    @State private var number = 99
    @State private var secondNumber = 0
    
    struct NumberView: ViewModifier, Animatable {
        var number: Int

        var animatableData: CGFloat {
            get { CGFloat(number) }
            set { number = Int(newValue) }
        }

        func body(content: Content) -> some View {
            Text(String(number))
        }
    }
    
    @ViewBuilder
    var testCase5: some View {
        VStack {
            Text("\(number)")
                .font(.system(size: 36))
                .contentTransition(.numericText())
                .onTapGesture {
                    withAnimation(.default.speed(2)) { // Speed 2 apply 2 times faster the current animation
                        //                    number = "98"
                        number -= 1
                    }
                }
            
            Spacer()
            
            VStack {
                Text(String(secondNumber))
                    .font(.system(size: 36))
                    .modifier(NumberView(number: secondNumber))
                
                Button("Animate") {
                    withAnimation(Animation.easeInOut(duration: 2)) {
                        secondNumber = (secondNumber == 0) ? 100 : 0
                    }
                }
            }
        }
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
    AnimationView()
}
