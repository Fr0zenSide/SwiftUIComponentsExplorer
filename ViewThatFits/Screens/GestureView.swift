//
//  GestureView.swift
//  ViewThatFits
//
//  Created by Jeoffrey Thirot on 09/04/2024.
//

import SwiftUI

extension GestureView {
    fileprivate enum TestCases: Int, Identifiable, CustomStringConvertible, CaseIterable {
        var id: Int { rawValue }
        
        case first, second, third, fourth, fifth, sixth, seventh, eighth//, ninth
        
        var description: String {
            let index = Self.allCases.firstIndex(of: self)!
            return RomanNumeralFormatter.convert(for: index + 1)
        }
    }
}

struct GestureView: View {
    
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
    
    @ViewBuilder
    var testCase1: some View {
        VStack {
            Circle()
                .fill(.red)
                .frame(width: 200, height: 200)
                .onTapGesture {
                    print("Circle tapped")
                }
        }
        .onTapGesture {
            print("VStack tapped")
        }
    }
    
    @ViewBuilder
    var testCase2: some View {
        VStack {
            Circle()
                .fill(.red)
                .frame(width: 200, height: 200)
                .onTapGesture {
                    print("Circle tapped")
                }
        }
        .simultaneousGesture(
            TapGesture()
                .onEnded { _ in
                    print("VStack tapped")
                }
        )
    }
    
    @State private var message = "Long press then drag"
    
    @ViewBuilder
    var testCase3: some View {
        let longPress = LongPressGesture()
            .onEnded { _ in
                message = "Now drag me"
            }
        
        let drag = DragGesture()
            .onEnded { _ in
                message = "Success!"
            }
        
        let combined = longPress.sequenced(before: drag)
        
        Text(message)
            .gesture(combined)
    }
    
    @State private var users = ["Glenn", "Malcolm", "Nicola", "Terri"]
    
    @ViewBuilder
    var testCase4: some View {
        List($users, id: \.self, editActions: .move) { $user in
            Text(user)
                .moveDisabled(user == users.first!)
        }
    }
    
    @State private var users2 = ["Paul", "Taylor", "Adele"]
    
    @ViewBuilder
    var testCase5: some View {
        List {
            ForEach(users2, id: \.self) { user in
                Text(user)
            }
            .onMove(perform: move)
        }
        .toolbar {
            EditButton()
        }
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        users2.move(fromOffsets: source, toOffset: destination)
    }
    
    @ViewBuilder
    var testCase6: some View {
        List {
            Text("Pepperoni pizza")
                .swipeActions {
                    Button("Order") {
                        print("Awesome!")
                    }
                    .tint(.green)
                }
            
            Text("Pepperoni with pineapple")
                .swipeActions {
                    Button("Burn") {
                        print("Right on!")
                    }
                    .tint(.red)
                }
        }
    }
    
    let friends = ["Antoine", "Bas", "Curt", "Dave", "Erica"]
    
    @ViewBuilder
    var testCase7: some View {
        List {
            ForEach(friends, id: \.self) { friend in
                Text(friend)
                    .swipeActions(allowsFullSwipe: false) {
                        Button {
                            print("Muting conversation")
                        } label: {
                            Label("Mute", systemImage: "bell.slash.fill")
                        }
                        .tint(.indigo)
                        
                        Button(role: .destructive) {
                            print("Deleting conversation")
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                    }
            }
        }
    }
    
    @State private var total = 0
    
    @ViewBuilder
    var testCase8: some View {
        List {
            ForEach(1..<100) { i in
                Text("\(i)")
                    .swipeActions(edge: .leading) {
                        Button {
                            total += i
                        } label: {
                            Label("Add \(i)", systemImage: "plus.circle")
                        }
                        .tint(.indigo)
                    }
                    .swipeActions(edge: .trailing) {
                        Button {
                            total -= i
                        } label: {
                            Label("Subtract \(i)", systemImage: "minus.circle")
                        }
                    }
            }
        }
        .navigationTitle("Total: \(total)")
    }
    
    @ViewBuilder
    var testCase9: some View {
        EmptyView()
    }
}

#Preview {
    GestureView()
}
