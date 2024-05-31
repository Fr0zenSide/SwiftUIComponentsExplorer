//
//  ToastView.swift
//  ToastView
//
//  Created by Jeoffrey Thirot on 22/07/2022.
//

import SwiftUI

struct ToastView: View {

    var type: ToastStyle
    var title: String
    var message: String
    var onCancelTapped: (() -> Void)

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Image(systemName: type.iconFileName)
                    .foregroundColor(type.themeColor)

                VStack(alignment: .leading) {
                    Text(title)
                        .font(.system(size: 14, weight: .semibold))

                    Text(message)
                        .font(.system(size: 12))
                        .foregroundColor(Color.black.opacity(0.6))
                }

                #if os(iOS)
                Spacer(minLength: 10)

                Button {
                    onCancelTapped()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(Color.black)
                }
                #endif
            }
            .padding()
        }
        .background(Color.white)
        .overlay(
            Rectangle()
                .fill(type.themeColor)
                .frame(width: 6)
                .clipped()
            , alignment: .leading
        )
        .frame(minWidth: 0, maxWidth: .infinity)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 1)
        .padding(.horizontal, 16)
    }
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack {
                ForEach(ToastStyle.allCases, id: \.self) { style in
                    ToastView(
                        type: style,
                        title: "Titou",
                        message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
                        onCancelTapped: {}
                    )
                }
            }
        }
    }
}
