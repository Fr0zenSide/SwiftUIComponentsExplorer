//
//  HeaderAndScrollView.swift
//  ViewThatFits
//
//  Created by Jeoffrey Thirot on 12/04/2024.
//

import SwiftUI

extension HeaderAndScrollView {
    fileprivate enum TestCases: Int, Identifiable, CustomStringConvertible, CaseIterable {
        var id: Int { rawValue }
        
        case first, second, third//, fourth, fifth, sixth, seventh, eighth, ninth
        
        var description: String {
            let index = Self.allCases.firstIndex(of: self)!
            return RomanNumeralFormatter.convert(for: index + 1)
        }
    }
}

struct HeaderAndScrollView: View {
    
    @State private var selectedTestCase: TestCases = .first
    
    init(orig: Binding<CGRect> = .variable(CGRect.zero), red: Binding<CGRect> = .variable(CGRect.zero)) {
        self._orig = orig
        self._red = red
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
//            case .fourth:
//                testCase4
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
    
    @Namespace var namespace
    @Binding var orig: CGRect {
        didSet {
            print("didSet orig: \(orig)")
        }
    }
    @Binding var red: CGRect {
        didSet {
            print("didSet red: \(red)")
        }
    }
    
    @ViewBuilder
    var testCase1: some View {
        GeometryReader { outerGeo in
        }
//        ScrollViewReader { proxy in
//            /*@START_MENU_TOKEN@*/Text("Placeholder")/*@END_MENU_TOKEN@*/
//        }
        GeometryReader { outerGeo in
            let _ = print("outerGeo size: \(outerGeo.size); frame: \(outerGeo.frame(in: .named("origin"))); bound: \(outerGeo.bounds(of: .named("red")))")
            let outerHeight = outerGeo.size.height
//            let outerHeight = proxy.size.height
                ScrollView(.vertical) {
                    Color.red // .clear
                        .task {
                            $red.wrappedValue = CGRect(origin: CGPoint(x: outerGeo.safeAreaInsets.leading, y: outerGeo.safeAreaInsets.top), size: outerGeo.size)
                            print("$red: \(red)")
//                                $width.wrappedValue = max(outerGeo., 0)
                        }
                        .frame(width: 1, height: 1)
                        .coordinateSpace(.named("red"))
                    bodyScrollView // scrollable content
                        
    //                    .background {
                        .overlay {
                            Color.green // .clear
                                .task {
                                    $orig.wrappedValue = CGRect(origin: CGPoint(x: outerGeo.safeAreaInsets.leading, y: outerGeo.safeAreaInsets.top), size: outerGeo.size)
                                    print("$orig: \(orig)")
    //                                $width.wrappedValue = max(outerGeo., 0)
                                }
                                .frame(width: 1, height: 1)
                                .coordinateSpace(.named("origin"))
                            GeometryReader { innnerGeo in
                                let contentHeight = innnerGeo.size.height
                                let minY = max(
                                    min(0, innnerGeo.frame(in: .named("ScrollView")).minY),
                                    outerHeight - contentHeight
                                )
    //                            Color.clear
    //                                .onChange(of: minY) { oldVal, newVal in
    //                                    if (canShowHeader && newVal < oldVal) || !canShowHeader && newVal > oldVal {
    //                                        canShowHeader = newVal > oldVal
    //                                    }
    //                                }
                            }
                        }
                }
            .coordinateSpace(name: "ScrollView") // coordinator space
        }
//        .onChange(of: outerGeo) {
//            
//        }
        .padding(.top, 1)
        .onChange(of: orig) {
            print("onChange orig: \(orig)")
        }
        .onChange(of: red) {
            print("onChange red: \(red)")
        }
        .onAppear {
            
        }
    }
    
    @ViewBuilder
    var bodyScrollView: some View {
        ForEach(0..<50) { index in
            Text("Item \(index)")
                .frame(height: 50)
                .cornerRadius(10)
                .frame(maxWidth: .infinity)
                .background(Color.blue)
        }
    }
    
    
    // MARK: - tab II
    
    @ViewBuilder
    var testCase2: some View {
        allView
    }
    
    
    @ViewBuilder
    var allView: some View {
        TrackableScrollView {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(0..<15) { index in
                        Text("Item \(index)")
                            .frame(width: 60, height: 50)
                            .background(Color.green)
                            .cornerRadius(10)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                    }
                }
                .padding()
            }
            .background(Color.pink)
        } content: {
            ForEach(0..<50) { index in
                Text("Item \(index)")
                    .frame(height: 50)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
            }
        }
    }
    
    
    // MARK: - tab III
    
    @ViewBuilder
    var testCase3: some View {
        EmptyView()
    }
    
    
    // MARK: - tab IV
    
    @ViewBuilder
    var testCase4: some View {
        EmptyView()
    }
    
    
    // MARK: - tab V
    
    @ViewBuilder
    var testCase5: some View {
        EmptyView()
    }
    
    
    // MARK: - tab VI
    
    @ViewBuilder
    var testCase6: some View {
        EmptyView()
    }
    
    
    // MARK: - tab VII
    
    @ViewBuilder
    var testCase7: some View {
        EmptyView()
    }
    
    
    // MARK: - tab VIII
    
    @ViewBuilder
    var testCase8: some View {
        EmptyView()
    }
    
    
    // MARK: - tab IX
    
    @ViewBuilder
    var testCase9: some View {
        EmptyView()
    }
}

struct TrackableScrollView<Header: View, Content: View>: View {
    @State private var canShowHeader = true // on of the header
    let header: () -> Header
    let content: () -> Content
    var body: some View {
        VStack {
            if canShowHeader {
                VStack {
                    header() // header content
                }
                .transition(
                    .asymmetric(
                        insertion: .push(from: .top),
                        removal: .push(from: .bottom)
                    )
                )
            }
            GeometryReader { outerGeo in
                let outerHeight = outerGeo.size.height
                ScrollView(.vertical) {
                    content() // scorllable content
                        .background {
                            GeometryReader { innnerGeo in
                                let contentHeight = innnerGeo.size.height
                                let minY = max(
                                    min(0, innnerGeo.frame(in: .named("ScrollView")).minY),
                                    outerHeight - contentHeight
                                )
                                Color.clear
                                    .onChange(of: minY) { oldVal, newVal in
                                        if (canShowHeader && newVal < oldVal) || !canShowHeader && newVal > oldVal {
                                            canShowHeader = newVal > oldVal
                                        }
                                    }
                            }
                        }
                }
                .coordinateSpace(name: "ScrollView") // coordinator space
            }
            .padding(.top, 1)
        }
        .background(.black)
        .animation(.easeInOut, value: canShowHeader)
    }
}
#Preview {
    HeaderAndScrollView()
}
