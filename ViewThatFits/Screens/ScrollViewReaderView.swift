//
//  ScrollViewReaderView.swift
//  ViewThatFits
//
//  Created by Jeoffrey Thirot on 09/04/2024.
//

import SwiftUI

extension ScrollViewReaderView {
    fileprivate enum TestCases: Int, Identifiable, CustomStringConvertible, CaseIterable {
        var id: Int { rawValue }
        
        case first, second, third, fourth, fifth, sixth, seventh, eighth, ninth
        
        var description: String {
            let index = Self.allCases.firstIndex(of: self)!
            return RomanNumeralFormatter.convert(for: index + 1)
//            return "Test " + String(index)
        }
    }
}

struct ScrollViewReaderView: View {
    
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
            case .fifth:
                testCase5
            case .sixth:
                testCase6
            case .seventh:
                testCase7
            case .eighth:
                testCase8
            case .ninth:
                testCase9
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
    
    let colors: [Color] = [.red, .green, .blue]
    
    @ViewBuilder
    var testCase1: some View {
        ScrollViewReader { value in
            ScrollView {
                Button("Jump to #8") {
                    withAnimation(.easeInOut) {
                        value.scrollTo(8)
                    }
                }
                .padding()
                
                ForEach(0..<100) { i in
                    Text("Example \(i)")
                        .font(.title)
                        .frame(width: 200, height: 200)
                        .background(colors[i % colors.count])
                        .id(i)
                }
            }
        }
        .frame(height: 350)
    }
    
    @State var dragAmount = CGSize.zero
    
    @ViewBuilder
    var testCase2: some View {
        ScrollViewReader { value in
            ScrollView {
                Button("Jump to #8") {
                    withAnimation(.easeInOut) {
                        value.scrollTo(8, anchor: .top)
                    }
                }
                .padding()
                
                ForEach(0..<100) { i in
                    Text("Example \(i)")
                        .font(.title)
                        .frame(width: 200, height: 200)
                        .background(colors[i % colors.count])
                        .id(i)
                }
            }
        }
        .frame(height: 350)
    }
    
    @State private var username = "Anonymous"
    @State private var bio = ""
    
    @ViewBuilder
    var testCase3: some View {
        ScrollView {
            VStack {
                TextField("Name", text: $username)
                    .textFieldStyle(.roundedBorder)
                TextEditor(text: $bio)
                    .frame(height: 400)
                    .border(.quaternary, width: 1)
            }
            .padding(.horizontal)
        }
        .scrollDismissesKeyboard(.interactively) // .immediately
    }
    
    @ViewBuilder
    var testCase4: some View {
        ScrollView {
            ForEach(0..<50) { i in
                Text("Item \(i)")
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .foregroundStyle(.white)
            }
        }
        .contentMargins(.top, 150, for: .scrollIndicators)
        .contentMargins(.top, 100, for: .scrollContent)
    }
    
    @ViewBuilder
    var testCase5: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(0..<10) { i in
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color(hue: Double(i) / 10, saturation: 1, brightness: 1).gradient)
                        .frame(width: 300, height: 100)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .safeAreaPadding(.horizontal, 40)
    }
    
    @ViewBuilder
    var testCase6: some View {
        ScrollView {
            ForEach(0..<50) { i in
                Text("Item \(i)")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(.rect(cornerRadius: 20))
            }
        }
        .scrollTargetBehavior(.paging)
    }
    
    @ViewBuilder
    var testCase7: some View {
        ScrollView {
            ForEach(0..<10) { i in
                RoundedRectangle(cornerRadius: 25)
                    .fill(.blue)
                    .frame(height: 80)
                    .scrollTransition { content, phase in
                        content
                            .opacity(phase.isIdentity ? 1 : 0)
                            .scaleEffect(phase.isIdentity ? 1 : 0.75)
                            .blur(radius: phase.isIdentity ? 0 : 10)
                    }
                    .padding(.horizontal)
            }
        }
    }
    
    @ViewBuilder
    var testCase8: some View {
        ScrollView {
            ForEach(0..<10) { i in
                RoundedRectangle(cornerRadius: 25)
                    .fill(.blue)
                    .frame(height: 80)
                    .scrollTransition(.animated.threshold(.visible(0.9))) { content, phase in
                        content
                            .opacity(phase.isIdentity ? 1 : 0)
                            .scaleEffect(phase.isIdentity ? 1 : 0.75)
                            .blur(radius: phase.isIdentity ? 0 : 10)
                    }
                    .padding(.horizontal)
            }
        }
    }
    
    // If you need very precise control over the effects that are applied, read the value of the transition phase. This will be -1 for views in the top leading phase, 1 for views in the bottom trailing phase, and 0 for all other views.
    @ViewBuilder
    var testCase9: some View {
        ScrollView {
            ForEach(0..<10) { i in
                RoundedRectangle(cornerRadius: 25)
                    .fill(.blue)
                    .frame(height: 80)
                    .shadow(radius: 3)
                    .scrollTransition { content, phase in
                        content
                            .hueRotation(.degrees(45 * phase.value))
                    }
                    .padding(.horizontal)
            }
        }
    }
}

#Preview {
    ScrollViewReaderView()
}
