//
//  PresentToastView.swift
//  ViewThatFits
//
//  Created by Jeoffrey Thirot on 17/04/2024.
//

import SwiftUI

extension PresentToastView {
    fileprivate enum TestCases: Int, Identifiable, CustomStringConvertible, CaseIterable {
        var id: Int { rawValue }
        
        case first, second, third, fourth//, fifth, sixth, seventh, eighth, ninth
        
        var description: String {
            let index = Self.allCases.firstIndex(of: self)!
            return RomanNumeralFormatter.convert(for: index + 1)
        }
    }
}

struct PresentToastView: View {
    
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
////            case .fifth:
////                testCase5
////            case .sixth:
////                testCase6
////            case .seventh:
////                testCase7
////            case .eighth:
////                testCase8
////            case .ninth:
////                testCase9
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
    
    @State var capses = [CapsItem]()
    
    @ViewBuilder
    var testCase1: some View {
        VStack {
            Spacer()
            
            Button("Show new toast") {
                capses.present(capses.randomSample)
            }
            
            Spacer()

        }
        .caps($capses)
    }
    
    
    // MARK: - tab II
    
    @ViewBuilder
    var testCase2: some View {
        VStack {
            Spacer()
            
            Button("Show new toast") {
                capses.present(capses.randomSample)
            }
            
            Spacer()

        }
        .caps($capses, orientation: .top)
    }
    
    
    // MARK: - tab III
    
    @State var toast: ToastModel? = nil
    @ViewBuilder
    var testCase3: some View {
        VStack {
            Spacer()
            
            ForEach(ToastStyle.allCases, id: \.self) { style in
                Button("Show new \(style) toast") {
                    if toast != nil {
                        withAnimation {
                            toast = nil
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                toast = ToastModel(type: style, title: "Toast title", message: "Toast message")
                            }
                        }
                        
                        return
                    }
                    toast = ToastModel(type: style, title: "Toast title", message: "Toast message")
                }
                .padding()
            }
            
            Spacer()
        }
        .toastView($toast)
    }
    
    
    // MARK: - tab IV
    
    @State var toasters: [ToasterModel] = []
    @ViewBuilder
    var testCase4: some View {
        VStack {
            Spacer()
            
            ForEach(ToasterStyle.allCases) { style in
                Button("Show new \(style) toaster") {
                    
                    let toast = ToasterModel(type: style, title: "Toast title", description: "Toast message", hasUserInteractionEnabled: true)
                    toasters.append(toast)
                }
                .padding()
            }
            
            Spacer()
        }
        .toaster($toasters)
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
    PresentToastView()
}
