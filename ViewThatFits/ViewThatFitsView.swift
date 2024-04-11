//
//  ViewThatFitsView.swift
//  ViewThatFits
//
//  Created by Jeoffrey Thirot on 09/04/2024.
//

import SwiftUI

extension ViewThatFitsView {
    fileprivate enum TestCases: Int, Identifiable, CustomStringConvertible, CaseIterable {
        var id: Int { rawValue }
        
        case first, second, thrid, fourth, fifth
        
        var description: String {
            switch self {
            case .first:
                "Test 1"
            case .second:
                "Test 2"
            case .thrid:
                "Test 3"
            case .fourth:
                "Test 4"
            case .fifth:
                "Test 5"
            }
        }
    }
}

struct ViewThatFitsView: View {
    
    @State private var selectedTestCase: TestCases = .first
    
    let terms = String(repeating: "abcde ", count: 100)
    
    var body: some View {
        VStack {
            switch selectedTestCase {
            case .first:
                testCase1
            case .second:
                testCase2
            case .thrid:
                testCase3
            case .fourth:
                testCase4
            case .fifth:
                testCase5
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
        ViewThatFits {
            Label("Welcome to AwesomeApp", systemImage: "bolt.shield")
                .font(.largeTitle)
            
            Label("Welcome", systemImage: "bolt.shield")
                .font(.largeTitle)
            
            Label("Welcome", systemImage: "bolt.shield")
        }
    }
    
    @ViewBuilder
    var testCase2: some View {
        ViewThatFits {
            HStack(content: OptionsView.init)
            VStack(content: OptionsView.init)
        }
    }
    
    @ViewBuilder
    var testCase3: some View {
        ViewThatFits {
            HStack {
                Text("The rain")
                Text("in Spain")
                Text("falls mainly")
                Text("on the Spaniards")
            }

            VStack {
                Text("The rain")
                Text("in Spain")
                Text("falls mainly")
                Text("on the Spaniards")
            }
        }
        .font(.title)
    }
    
    @ViewBuilder
    var testCase4: some View {
        ViewThatFits {
            Text(terms)
            
            ScrollView {
                Text(terms)
            }
        }
    }
    
    @ViewBuilder
    var testCase5: some View {
        // add the scrolling only when we need it (big than the screen area)
        ViewThatFits(in: .vertical) {
            Text(terms)
            
            ScrollView {
                Text(terms)
            }
        }
    }
}

struct OptionsView: View {
    var body: some View {
        Button("Log in") { }
            .buttonStyle(.borderedProminent)

        Button("Create Account") { }
            .buttonStyle(.bordered)

        Button("Settings") { }
            .buttonStyle(.bordered)

        Spacer().frame(width: 50, height: 50)

        Button("Need Help?") { }
    }
}

#Preview {
    ViewThatFitsView()
}
