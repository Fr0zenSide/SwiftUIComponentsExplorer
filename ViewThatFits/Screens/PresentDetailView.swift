//
//  PresentDetailView.swift
//  ViewThatFits
//
//  Created by Jeoffrey Thirot on 10/04/2024.
//

import SwiftUI

extension PresentDetailView {
    fileprivate enum TestCases: Int, Identifiable, CustomStringConvertible, CaseIterable {
        var id: Int { rawValue }
        
        case first, second, third//, fourth, fifth, sixth, seventh, eighth, ninth
        
        var description: String {
            let index = Self.allCases.firstIndex(of: self)!
            return RomanNumeralFormatter.convert(for: index + 1)
        }
    }
}

struct PresentDetailView: View {
    
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
            .zIndex(-1)
        }
    }
    
    
    // MARK: - tab I
    
    @State private var slowAnimations = false
    @State private var showPreview = false {
        didSet {
            if showPreview == false {
                withAnimation {
                    showBg = false
                }
            }
        }
    }
//    @Binding var hiddingPreview = Binding(
//        get: { !showPreview },
//        set: { newValue in /* implement */ }
//    )
    
    @State private var showBg = false
    @Namespace private var animation
    
    private let columns = [GridItem(.adaptive(minimum: 80, maximum: 120))]
    @State private var currentImageTap = 1
        
    @ViewBuilder
    var testCase1: some View {
        VStack {
            Toggle("Slow Animations", isOn: $slowAnimations)
            ZStack {
                contentView
                    .padding()
                
//                if showPreview {
                    PresentContainerView(isPresented: $showPreview) {
                        //                    ContainerRelativeShape()
                        //                    VStack {
                        imageView
                        //                        .position(/*@START_MENU_TOKEN@*/CGPoint(x: 10.0, y: 10.0)/*@END_MENU_TOKEN@*/)
                        //                    }
                            .onAppear {
                                showBg = true
                            }
                        //                        .background(
                        //                            Rectangle()
                        //                                .fill(.thinMaterial)
                        //                                .opacity(showBg ? 1 : 0)
                        //                                .ignoresSafeArea()
                        //                                .onTapGesture {
                        //                                    withAnimation {
                        //                                        showPreview.toggle()
                        //                                    }
                        //                                })
                    }
                    .hidden($showPreview.not)
//                }
            }
            .animation(.default.speed(slowAnimations ? 0.2 : 1), value: showPreview)
        }
    }
    
    @ViewBuilder
    var contentView: some View {
        VStack {
            LazyVGrid(columns: columns, spacing: 0) {
//            VStack {
//                ScrollView {
                ForEach(1...12, id: \.self) { index in
                    imageBg
                        .cornerRadius(5)
//                        .id("image-\(index)")
                        .shadow(color: .gray, radius: 10, x: 4, y: 4)
//                        .padding([.leading, .trailing], 20)
                        .matchedGeometryEffect(id: "image-\(index)",
                                               in: animation)//,
//                                               properties: .frame)
//                        .frame(minWidth: 70, maxWidth: 450, minHeight: 60, maxHeight: 350)
                        .frame(width: 90, height: 60)
                        .aspectRatio(contentMode: .fit)
                        .opacity((showPreview && currentImageTap == index) ? 0 : 1)
//                        .hidden($showPreview && currentImageTap == index)
                        .onTapGesture {
                            withAnimation {
                                currentImageTap = index
                                showPreview.toggle()
                            }
                        }
                }
            }
            
            Text("My super legend")
                .font(.headline)
                .padding(0)
            
            Spacer()
        }
    }
    
    @ViewBuilder
    var imageBg: some View {
        Image("background")
            .resizable()
//            .aspectRatio(contentMode: .fit)
            .border(.yellow, width: 1)
    }
    
    @ViewBuilder
    var imageView: some View {
        VStack {
            imageBg
//                .scaledToFit()
                .cornerRadius(20)
//                .id("image-\(currentImageTap)")
//                .shadow(color: .gray, radius: 10, x: 8, y: 15)
                .border(.pink, width: 1)
                
                .matchedGeometryEffect(id: "image-\(currentImageTap)",
                                       in: animation,
//                                       properties: .frame,
                                       isSource: false)
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .padding()
                .closeDraggable(stopToDisplay: $showPreview)
//                            .shadow(color: .gray, radius: 10, x: 8, y: 15)
                
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .padding([.leading, .trailing], 5)
        }
        .border(.red, width: 1)
    }
    
    
    // MARK: - tab II
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @State private var cards = Array<Card>(repeating: .example, count: 10)
    
    @ViewBuilder
    var testCase2: some View {
        ZStack {
            Image(.background)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            VStack {
                ZStack {
                    ForEach(Array(cards.enumerated()), id: \.offset) { index, card in
                        CardView(card: card) {
                            withAnimation {
                                removeCard(at: index)
                            }
                        }
                        .stacked(at: index, in: cards.count)
                    }
                    
                    if accessibilityDifferentiateWithoutColor/* || true*/ {
                        accessibilityIndicatorView
                    }
                }
//                .border(.pink, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            }
            .overlay(
                accessibilityIndicatorView
            )
//            // Background don't fit properly images
//            .background(
//                Image(.background)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .ignoresSafeArea()
//            )
        }
    }
    
    @ViewBuilder
    var accessibilityIndicatorView: some View {
        VStack {
            Spacer()
            
            HStack {
                Image(systemName: "xmark.circle")
                    .padding()
                    .background(.black.opacity(0.7))
                    .clipShape(.circle)
                
                if horizontalSizeClass == .regular {
                    Spacer()
                }
                
                let _ = print("horizontalSizeClass: ", horizontalSizeClass as Any)
                let _ = print("verticalSizeClass: ", verticalSizeClass as Any)
                
                Image(systemName: "checkmark.circle")
                    .padding()
                    .background(.black.opacity(0.7))
                    .clipShape(.circle)
            }
            .foregroundStyle(.white)
            .font(.largeTitle)
            .padding()
//            .border(.yellow, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
        }
    }
    
    func removeCard(at index: Int) {
        cards.remove(at: index)
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

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(y: offset * 10)
    }
}

struct Card/*: Identifiable*/ {
    
//    let id: UUID = UUID()
    let prompt: String
    let answer: String
    
    static var example: Self { .init(prompt: "Coucou", answer: "Didou") }
}

struct CardView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @State private var offset: CGSize = .zero
    @State private var isShowingAnswer = false
    
    let card: Card
    var removal: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    accessibilityDifferentiateWithoutColor
                    ? .white
                    : .white
                        .opacity(1 - Double(abs(offset.width / 75.0))))
                .background(
                    accessibilityDifferentiateWithoutColor
                    ? nil
                    : RoundedRectangle(cornerRadius: 25)
                        .fill(offset.width > 0 ? .green : .red)
                )
                .shadow(radius: 10)
            
            VStack {
                Text(card.prompt)
                    .font(.largeTitle)
                    .foregroundStyle(.black)
                
                if isShowingAnswer {
                    Text(card.answer)
                        .font(.title)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
//        .frame(width: 450, height: 250)
        .frame(minWidth: 330, maxWidth: 350, minHeight: 220, maxHeight: 250)
        .rotationEffect(.degrees(offset.width / 5.0))
        .offset(x: offset.width * 2.5)
        .opacity(2 - Double(abs(offset.width / 75.0)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { gesture in
                    if abs(offset.width) > 100 {
                        removal?()
                    } else {
                        offset = .zero
                    }
                })
        .onTapGesture {
            withAnimation {
                isShowingAnswer.toggle()
            }
        }
    }
}

#Preview {
    PresentDetailView()
}
