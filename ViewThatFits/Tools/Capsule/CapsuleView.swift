//
//  CapsuleView.swift
//  ViewThatFits
//
//  Created by Jeoffrey Thirot on 17/04/2024.
//

import SwiftUI

struct CapsuleView: View {
//    @State var capses = [CapsItem]()
    
    @State var capses: [CapsItem] = [.init(title: "AirPods Pro", symbol: "airpodspro", tint: .indigo.opacity(0.7), hasUserInteractionEnabled: true, timing: .long)]
    
    var body: some View {
        VStack {
            Spacer()
            
            Button("Show new caps") {
                capses.present(capses.randomSample)
            }
            
            Spacer()
            
        }
        .caps($capses, orientation: .top)
    }
}

#Preview {
    CapsuleView()
}

extension Array where Element == CapsItem {
    var samples: [CapsItem] {
        [
            .init(title: "AirPods Pro", symbol: "airpodspro", tint: .indigo.opacity(0.7), hasUserInteractionEnabled: true),
            .init(title: "Music", symbol: "airpodsmax", tint: .pink.opacity(0.7), hasUserInteractionEnabled: true),
            .init(title: "Battery low", symbol: "battery.75", tint: .green.opacity(0.7), hasUserInteractionEnabled: true),
            .init(title: "Take a break", symbol: "sun.max", tint: .gray.opacity(0.5), hasUserInteractionEnabled: true)
        ]
    }
    var randomSample: CapsItem { samples.randomElement()! }
    
    mutating func present(title: String,
                 symbol: String? = nil,
                 tint: Color = .primary,
                 hasUserInteractionEnabled: Bool = false,
                 timing: CapsTime = .medium) {
        self.present(CapsItem(title: title,
                              symbol: symbol,
                              tint: tint,
                              hasUserInteractionEnabled: hasUserInteractionEnabled,
                              timing: timing))
    }
    
    mutating func present(_ item: CapsItem) {
        withAnimation(.snappy) {
            self.append(item)
        }
    }
}

enum CapsTime: CGFloat {
    case short  = 1.0
    case medium = 2.0
    case long   = 3.5
}

struct CapsItem: Identifiable {
    var id: UUID = UUID()
    
    var title: String
    var symbol: String?
    var tint: Color
    var hasUserInteractionEnabled: Bool
    var timing: CapsTime = .medium
}

enum CapsOrientation {
    case top, bottom
}

struct CapsModifier: ViewModifier {
    
    @Binding var capses: [CapsItem]
    var orientation: CapsOrientation
    
    /*
    func body(content: Content) -> some View {
        ZStack {
            content
            
            GeometryReader {
                let size = $0.size
                let safeArea = $0.safeAreaInsets
                
                ZStack {
                    Text("\(capses.count)")
                        .offset(y: -100)
                    
                    ForEach(capses) { caps in
                        CapsView(size: size, item: caps, onRemove: removeCaps)
                            .scaleEffect(scale(caps))
                            .offset(y: offsetY(caps))
                            .zIndex(toastIndex(caps))
                            .animation(.spring(), value: model.capses.count)
                    }
                }
                .padding(.bottom, safeArea.top == .zero ? 15 : 10)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .background(.purple.opacity(0.3))
            }
        }
    }
    */
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay/*(alignment: .bottom)*/ {
                GeometryReader {
                    let size = $0.size
                    let safeArea = $0.safeAreaInsets
//                    let _ = print("safeArea:", safeArea)
                    
                    ZStack {
                        Text("\(capses.count)")
                            .offset(y: orientation == .bottom ? -100 : 100)
                        
                        ForEach(capses) { caps in
                            CapsView(size: size, item: caps, orientation: orientation, onRemove: removeCaps)
                                .scaleEffect(scale(caps))
                                .offset(y: offsetY(caps))
                                .zIndex(capsIndex(caps))
//                                .animation(.easeInOut, value: offsetY(caps))
                                .animation(.spring(), value: capses.count)
////                                .transition(asymTransition)
//                                .transition(.move(edge: .bottom))
//                                .transition(bottomTransition)
                        }
                    }
                    .padding(.top, safeArea.top == .zero ? 10 : 15)
                    .padding(.bottom, safeArea.top == .zero ? 10 : 15)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: orientation == .bottom ? .bottom : .top)
//                    .background(.purple.opacity(0.3))
                }
            }
    }
    
    private func removeCaps(_ item: CapsItem) {
        capses.removeAll { $0.id == item.id }
    }
    
    private func capsIndex(_ item: CapsItem) -> CGFloat {
        CGFloat(capses.firstIndex { $0.id == item.id } ?? 0)
    }
    
    private func offsetY(_ item: CapsItem) -> CGFloat {
        let index = capsIndex(item)
        let totalCount = CGFloat(capses.count - 1)
        // print("offsetY:", ((totalCount - index) >= 2 ? -20 : ((totalCount - index) * -10)))
        return (totalCount - index) >= 2 ? -20 : ((totalCount - index) * -10)
    }
    
    private func scale(_ item: CapsItem) -> CGFloat {
        let index = capsIndex(item)
        let totalCount = CGFloat(capses.count - 1)
        return 1.0 - ((totalCount - index) >= 2 ? 0.2 : ((totalCount - index) * 0.1))
    }
}

extension View {
    func caps(_ capses: Binding<[CapsItem]>, orientation: CapsOrientation = .bottom) -> some View {
        self.modifier(CapsModifier(capses: capses, orientation: orientation))
    }
}

fileprivate struct CapsView: View {
    var size: CGSize
    var item: CapsItem
    var orientation: CapsOrientation
    var onRemove: ((_ item: CapsItem) -> Void)? = nil
    
    @State private var delayTask: DispatchWorkItem?
    @State private var displayed: Bool = false
    private var offsetYAnim: CGFloat { orientation == .bottom ? 150 : -150 }
    
    var body: some View {
        Label(item.title, systemImage: item.symbol ?? "")
            .lineLimit(1)
            .font(.title3)
            .foregroundStyle(item.tint)
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
            .background(
                .background
                    .shadow(.drop(color: .primary.opacity(0.06), radius: 5, x: 5, y: 5))
                    .shadow(.drop(color: .primary.opacity(0.06), radius: 8, x: -5, y: -5)),
                in: .capsule
            )
            .contentShape(.capsule)
            .offset(y: displayed ? 0 : offsetYAnim)
            .opacity(displayed ? 1 : 0)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onEnded({ value in
                        guard item.hasUserInteractionEnabled else { return }
                        let endY = value.translation.height
                        let velocityY = value.velocity.height
                        
                        print("velo (\(endY),\(velocityY)):", (endY + velocityY))
                        if endY + velocityY > 100 || endY + velocityY < -100 {
                            removeCaps()
                        }
                    })
            )
            .onAppear {
                guard delayTask == nil else { return }
                
                withAnimation(.snappy) {
                    displayed = true
                }
                
                delayTask = DispatchWorkItem {
                    removeCaps()
                }
                
                if let delayTask {
                    DispatchQueue.main.asyncAfter(deadline: .now() + item.timing.rawValue, execute: delayTask)
                }
            }
            .frame(maxWidth: size.width * 0.7)
            .transition(.offset(y: offsetYAnim))
            .transition(.opacity)
    }
    
    func removeCaps() {
        if let delayTask {
            delayTask.cancel()
        }
        
        withAnimation(.snappy) {
            displayed = false
            onRemove?(item)
        }
    }
}
