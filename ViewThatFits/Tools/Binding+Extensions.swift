//
//  Binding+Extensions.swift
//  ViewThatFits
//
//  Created by Jeoffrey Thirot on 12/04/2024.
//  ref. https://medium.com/@Lakshmnaidu/how-to-invert-binding-as-not-value-values-in-swiftui-b0b6d0701395
//

import SwiftUI

/*
 //Example of usage
 struct SomeView: View {
     @State var isPresented = false
     var body: some View {
         VStack {
            Text("My text was hidden when I present my bottomsheet")
              .hidden($isPresented.not)
            Button("Show bottom sheet") {
              isPresented.toggle()
            }
         }
         .sheet(isPresented: $isPresented) {
            Text("This app was brought to you by Hacking with Swift")
              .presentationDetents([.medium, .large])
         }
     }
 }
 */
extension Binding where Value == Bool {
    // nagative bool binding same as `!Value`
    var not: Binding<Value> {
        Binding<Value> (
            get: { !self.wrappedValue },
            set: { self.wrappedValue = $0}
        )
    }
}

/*
 // Example of usage
 struct AmazinglyComplexView_Previews: PreviewProvider {
     static var previews: some View {
         AmazinglyComplexView(value: .variable(true))
     }
 }
 */
extension Binding {
    public static func variable(_ value: Value) -> Binding<Value> {
        var state = value
        return Binding<Value> {
            state
        } set: {
            state = $0
        }
    }
}

/*
 // Example of usage
 struct SomeView: View {
     @StateObject var viewModel = SomeViewModel()
     var body: some View{
         TextField("Name", text: $viewModel.name.defaultValue(""))
     }
 }
 */
extension Binding {
    public func defaultValue<T>(_ value: T) -> Binding<T> where Value == Optional<T> {
        Binding<T> {
            wrappedValue ?? value
        } set: {
            wrappedValue = $0
        }
    }
}

/*
 // Example of usage
 struct SomeView: View {
     @StateObject var viewModel = SomeViewModel()
     var body: some View{
         TextField("Name", text: $viewModel.name.orEmpty)
     }
 }
 */
extension Binding where Value == Optional<String> {
    public var orEmpty: Binding<String> {
        Binding<String> {
            wrappedValue ?? ""
        } set: {
            wrappedValue = $0
        }
    }
}
