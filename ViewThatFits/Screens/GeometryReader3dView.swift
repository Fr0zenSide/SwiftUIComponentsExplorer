//
//  GeometryReader3dView.swift
//  ViewThatFits
//
//  Created by Jeoffrey Thirot on 09/04/2024.
//

import SwiftUI

extension GeometryReader3dView {
    fileprivate enum TestCases: Int, Identifiable, CustomStringConvertible, CaseIterable {
        var id: Int { rawValue }
        
        case first, second
        
        var description: String {
            switch self {
            case .first:
                "Test 1"
            case .second:
                "Test 2"
            }
        }
    }
}

struct GeometryReader3dView: View {
    
    @State private var selectedTestCase: TestCases = .first
    
    var body: some View {
        VStack {
            switch selectedTestCase {
            case .first:
                testCase1
            case .second:
                testCase2
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
    
    
    @ViewBuilder
    var testCase1: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(1..<20) { num in
                    VStack {
                        GeometryReader { geo in
                            Text("Number \(num)")
                                .font(.largeTitle)
                                .padding()
                                .background(.red)
                                .rotation3DEffect(.degrees(-Double(geo.frame(in: .global).minX) / 8), axis: (x: 0, y: 1, z: 0))
                                .frame(width: 200, height: 200)
                        }
                        .frame(width: 200, height: 200)
                    }
                }
            }
        }
    }
    
    @State var dragAmount = CGSize.zero
    
    @ViewBuilder
    var testCase2: some View {
        VStack {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [.yellow, .red]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 200, height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .rotation3DEffect(.degrees(-Double(dragAmount.width) / 20), axis: (x: 0, y: 1, z: 0))
                .rotation3DEffect(.degrees(Double(dragAmount.height / 20)), axis: (x: 1, y: 0, z: 0))
                .offset(dragAmount)
                .gesture(
                    DragGesture()
                        .onChanged { dragAmount = $0.translation }
                        .onEnded { _ in
                            withAnimation(.spring()) {
                                dragAmount = .zero
                            }
                        }
                )
        }
        .frame(width: 400, height: 400)
    }
}

#Preview {
    GeometryReader3dView()
}
