//
//  ToastModifier.swift
//  ToastView
//
//  Created by Jeoffrey Thirot on 22/07/2022.
//

import SwiftUI

struct ToastModifier: ViewModifier {

    @Binding var toast: ToastModel?
    @State private var workItem: DispatchWorkItem?

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    mainToastView()
                        .offset(y: -30)
                }
                .animation(.spring(), value: toast)
            )
            .onChange(of: toast) { value in
                showToast()
            }
    }

    @ViewBuilder func mainToastView() -> some View {
        if let toast = toast {
            VStack {
                Spacer()
                ToastView(
                    type: toast.type,
                    title: toast.title,
                    message: toast.message) {
                        dismissToast()
                    }
            }
            .transition(.move(edge: .bottom))
        }
    }

    private func showToast() {
        guard let toast = toast else { return }
        #if os(iOS)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        #endif
        if toast.duration > 0 {
            workItem?.cancel()

            let task = DispatchWorkItem {
               dismissToast()
            }

            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
        }
    }

    private func dismissToast() {
        withAnimation {
            toast = nil
        }

        workItem?.cancel()
        workItem = nil
    }
}

extension View {
    func toastView(_ toast: Binding<ToastModel?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}

struct ToastModifier_Previews: PreviewProvider {
    static var previews: some View {
        @State var toast: ToastModel? = ToastModel(type: .success, title: "🎉", message: "Association Succeed", duration: 50)
        VStack {
            Text("Preview toast")
        }
        .toastView($toast)
    }
}
