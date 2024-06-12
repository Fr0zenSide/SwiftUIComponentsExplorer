//
//  ToasterView.swift
//  ViewThatFits
//
//  Created by Jeoffrey Thirot on 17/04/2024.
//

import SwiftUI

struct ToasterScreen: View {
//    @State var toasts = [ToasterModel]()
    
    @State var toasts: [ToasterModel] = [.init(type: .info, title: "AirPods Pro", hasUserInteractionEnabled: true, timing: .long)]
    
    var body: some View {
        VStack {
            Spacer()
            
            Button("Show new toast") {
                toasts.present(toasts.randomSample)
            }
            
            Spacer()
            
        }
        .toaster($toasts, orientation: .top)
    }
}

#Preview {
    ToasterScreen()
}

extension Array where Element == ToasterModel {
    var samples: [ToasterModel] {
        [
            .init(type: .info, title: "AirPods Pro", description: "It's time to update your phone."),
            .init(type: .success, title: "Music", description: "That's the moment to turn on the Music. 🎶🎶🎶"),
            .init(type: .error, title: "Battery low", description: "Why did you do this to me??!!! 🥲"),
            .init(type: .warning, title: "Take a break"),
            .init(type: .custom(color: .indigo.opacity(0.7), symbol: "airpodspro"), title: "AirPods Pro"),
            .init(type: .custom(color: .pink.opacity(0.7), symbol: "airpodsmax"), title: "Music"),
            .init(type: .custom(color: .green.opacity(0.7), symbol: "battery.75"), title: "Battery low"),
            .init(type: .custom(color: .gray.opacity(0.5), symbol: "sun.max"), title: "Take a break")
        ]
    }
    var randomSample: ToasterModel { samples.randomElement()! }
    
    mutating func present(for type: ToasterStyle,
                          title: String,
                          description: String? = nil,
                          tint: Color = .primary,
                          hasUserInteractionEnabled: Bool = false,
                          timing: ToasterTime = .medium) {
        self.present(ToasterModel(type: type,
                                  title: title,
                                  description: description,
                                  hasUserInteractionEnabled: hasUserInteractionEnabled,
                                  timing: timing))
    }
    
    mutating func present(_ item: ToasterModel) {
        #if os(iOS)
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        #endif
        withAnimation(.snappy) {
            self.append(item)
        }
    }
}

enum ToasterTime: CGFloat {
    // TODO: add behavior to take -1 in not disappearing mode
    case infinite   = -1.0
    case short      = 1.0
    case medium     = 2.0
    case long       = 3.5
}

struct ToasterModel: Identifiable {
    var id: UUID = UUID()
    
    var type: ToasterStyle
    var title: String
    var description: String? = nil
    var hasUserInteractionEnabled: Bool = true
    var timing: ToasterTime = .medium
}

enum ToasterOrientation {
    case top, bottom
}

struct ToasterModifier: ViewModifier {
    
    @Binding var items: [ToasterModel]
    var orientation: ToasterOrientation
    
    /*
    func body(content: Content) -> some View {
        ZStack {
            content
            
            GeometryReader {
                let size = $0.size
                let safeArea = $0.safeAreaInsets
                
                ZStack {
                    Text("\(items.count)")
                        .offset(y: -100)
                    
                    ForEach(items) { toast in
                        ToasterView(size: size, item: toast, onRemove: removeToaster)
                            .scaleEffect(scale(toast))
                            .offset(y: offsetY(toast))
                            .zIndex(toastIndex(toast))
                            .animation(.spring(), value: model.items.count)
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
                        Text("\(items.count)")
                            .offset(y: orientation == .bottom ? -100 : 100)
                        
                        ForEach(items) { toast in
                            ToasterView(size: size, item: toast, orientation: orientation, onRemove: removeToaster)
                                .scaleEffect(scale(toast))
                                .offset(y: offsetY(toast))
                                .zIndex(toasterIndex(toast))
//                                .animation(.easeInOut, value: offsetY(toast))
                                .animation(.spring(), value: items.count)
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
    
    private func removeToaster(_ item: ToasterModel) {
        items.removeAll { $0.id == item.id }
    }
    
    private func toasterIndex(_ item: ToasterModel) -> CGFloat {
        CGFloat(items.firstIndex { $0.id == item.id } ?? 0)
    }
    
    private func offsetY(_ item: ToasterModel) -> CGFloat {
        let index = toasterIndex(item)
        let totalCount = CGFloat(items.count - 1)
        // print("offsetY:", ((totalCount - index) >= 2 ? -20 : ((totalCount - index) * -10)))
        return (totalCount - index) >= 2 ? -20 : ((totalCount - index) * -10)
    }
    
    private func scale(_ item: ToasterModel) -> CGFloat {
        let index = toasterIndex(item)
        let totalCount = CGFloat(items.count - 1)
        return 1.0 - ((totalCount - index) >= 2 ? 0.2 : ((totalCount - index) * 0.1))
    }
}

extension View {
    func toaster(_ items: Binding<[ToasterModel]>, orientation: ToasterOrientation = .bottom) -> some View {
        self.modifier(ToasterModifier(items: items, orientation: orientation))
    }
}

fileprivate struct ToasterView: View {
    var size: CGSize
    var item: ToasterModel
    var orientation: ToasterOrientation
    var onRemove: ((_ item: ToasterModel) -> Void)? = nil
    
    @State private var delayTask: DispatchWorkItem?
    @State private var displayed: Bool = false
    private var offsetYAnim: CGFloat { orientation == .bottom ? 150 : -150 }
    
    var body: some View {
        let shape = item.type.shape
        cardView
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
            .background(
                .background
                    .shadow(.drop(color: .primary.opacity(0.06), radius: 5, x: 5, y: 5))
                    .shadow(.drop(color: .primary.opacity(0.06), radius: 8, x: -5, y: -5)),
                in: AnyShape(item.type.shape)
            )
            .contentShape(AnyShape(item.type.shape))
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
                            removeToaster()
                        }
                    })
            )
            .onAppear {
                guard delayTask == nil else { return }
                
                withAnimation(.snappy) {
                    displayed = true
                }
                
                delayTask = DispatchWorkItem {
                    removeToaster()
                }
                
                if let delayTask {
                    DispatchQueue.main.asyncAfter(deadline: .now() + item.timing.rawValue, execute: delayTask)
                }
            }
            .frame(maxWidth: size.width * 0.7)
            .transition(.offset(y: offsetYAnim))
            .transition(.opacity)
    }
    
    @ViewBuilder var cardView: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Image(systemName: item.type.symbol)
                    .foregroundColor(item.type.tint)

                VStack(alignment: .leading) {
                    Text(item.title)
                        .font(.system(size: 14, weight: .semibold))

                    if let description = item.description {
                        Text(description)
                            .font(.system(size: 12))
                            .foregroundColor(Color.black.opacity(0.6))
                    }
                }

                #if os(iOS)
                Spacer(minLength: 10)

                Button {
                    removeToaster()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(Color.black)
                }
                #endif
            }
            .padding()
        }
    }
    
    @ViewBuilder var capsuleView: some View {
        Label(item.title, systemImage: item.type.symbol)
            .lineLimit(1)
            .font(.title3)
            .foregroundStyle(item.type.tint)
    }
    
    func removeToaster() {
        if let delayTask {
            delayTask.cancel()
        }
        
        withAnimation(.snappy) {
            displayed = false
            onRemove?(item)
        }
    }
}
