//
//  ButtonsView.swift
//  ViewThatFits
//
//  Created by Jeoffrey Thirot on 26/04/2024.
//

import SwiftUI

extension ButtonsView {
    fileprivate enum TestCases: Int, Identifiable, CustomStringConvertible, CaseIterable {
        var id: Int { rawValue }
        
        case first, second, third//, fourth, fifth, sixth, seventh, eighth, ninth
        
        var description: String {
            let index = Self.allCases.firstIndex(of: self)!
            return RomanNumeralFormatter.convert(for: index + 1)
        }
    }
}

struct ButtonsView: View {
    
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
    
    @ViewBuilder
    var testCase1: some View {
        VStack(spacing: 10) {
            Button("Super button") {
                print("click on Super button")
            }
            .buttonStyle(.main)
            .padding()
            
            glowCapsule
                .frame(maxWidth: 175, maxHeight: 44)
            
            glowCapsule2
                .frame(maxWidth: 175, maxHeight: 44)
            
            glowCapsule3
                .frame(maxWidth: 175, maxHeight: 44)
            
            test
                .frame(maxWidth: 175, maxHeight: 44)
                .padding(8)
            
            loadingButton
                .frame(maxWidth: 175, maxHeight: 44)
                .padding()
            
            Text("Text with border")
                .glowing()
            
            loadingButton2
                .frame(maxWidth: 175, maxHeight: 44)
                .padding()
            
            loadingButton3
                .frame(maxWidth: 175, maxHeight: 24)
                .padding()
            
            loadingButton4
                .frame(maxWidth: 175, maxHeight: 24)
                .frame(height: 12)
                .padding()
        }
    }
    
    @State private var progress: Double = 0.0
    let delay = 0.2
    
    @ViewBuilder
    var glowCapsule: some View {
        Capsule()
            .trim(from: {
                if progress > delay {
                  progress - delay
                } else {
                  .zero
                }
              }(), to: progress)
            .glow(
                fill: .palette,
                lineWidth: 4.0
            )
            .onAppear() {
                withAnimation(
                    .linear(duration: 2.0)
                    .repeatForever(autoreverses: false)
                ) {
                    progress = 1.0
                }
            }
    }
    
    @State private var progress2: Double = 0.0
    
    @ViewBuilder
    var glowCapsule2: some View {
        CapsuleProgressView(progress: progress2)
            .onAppear() {
                withAnimation(
                    .linear(duration: 2.0)
                    .repeatForever(autoreverses: false)
                ) {
                    progress2 = 1.0
                }
            }
    }
    
    @ViewBuilder
    var glowCapsule3: some View {
        CapsuleProgress2View()
    }
    
    @ViewBuilder
    var test: some View {
        LabeledContent {
            Text("Titout")
        } label: {
            Text("Custom Value")
        }
    }
    
    @State var isLoadingTouched: Bool = false
    
    @ViewBuilder
    var loadingButton: some View {
        Button("Titou") {
            
            isLoadingTouched.toggle()
        }
        .buttonStyle(.loading($isLoadingTouched))
    }
    
    @ViewBuilder
    var loadingButton2: some View {
        Button("Titou") {
            
            isLoadingTouched.toggle()
        }
        .buttonStyle(.loading($isLoadingTouched, backgroundShape: Capsule()))
//        .disabled(true)
    }
    
    @ViewBuilder
    var loadingButton3: some View {
        Button("Titou") {
            
            isLoadingTouched.toggle()
        }
        .buttonStyle(.loadingSec($isLoadingTouched))
    }
    
    @ViewBuilder
    var loadingButton4: some View {
        Button("Titou") {
            
            isLoadingTouched.toggle()
        }
        .buttonStyle(.loadingSec($isLoadingTouched, backgroundShape: Capsule(), maxHeight: 38))
    }
    
    
    // MARK: - tab II
    
    @ViewBuilder
    var testCase2: some View {
        EmptyView()
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

#Preview {
    ButtonsView()
}
