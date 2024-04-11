//
//  ContentView.swift
//  ViewThatFits
//
//  Created by Jeoffrey Thirot on 09/04/2024.
//

import SwiftUI

enum NavItem: String, Identifiable, Hashable, CustomStringConvertible, CaseIterable {
    var id: String { rawValue }
    
    case viewThatFits, geometryReader3d, scrollViewReader, gesture, 
         search, tokenSearch,
         animation, phaseAnimator, presentDetail
    
    var description: String {
        switch self {
        case .viewThatFits:
            "ViewThatFits {} layout"
        case .geometryReader3d:
            "3D Geometry Reader in scrollView"
        case .scrollViewReader:
            "ScrollViewReader"
        case .gesture:
            "Gesture"
        case .search:
            "Search"
        case .tokenSearch:
            "Search with tokens"
        case .animation:
            "Animations"
        case .phaseAnimator:
            "Phase Animators"
        case .presentDetail:
            "Present detail with anim"
        }
    }
    
    @ViewBuilder
    var body: some View {
        switch self {
        case .viewThatFits:
            ViewThatFitsView()
        case .geometryReader3d:
            GeometryReader3dView()
        case .scrollViewReader:
            ScrollViewReaderView()
        case .gesture:
            GestureView()
        case .search:
            SearchView()
        case .tokenSearch:
            SearchWithTokenView()
        case .animation:
            AnimationView()
        case .phaseAnimator:
            PhaseAnimatorView()
        case .presentDetail:
            PresentDetailView()
        }
    }
}

struct ContentView: View {
    
    @State var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            List(NavItem.allCases) { item in
                NavigationLink(item.description, value: item)
            }
            .listStyle(.plain)
            .navigationDestination(for: NavItem.self) { item in
                item.body
            }
            .padding()
            .navigationTitle("SwiftUI tips")
        }
    }
}

#Preview {
    ContentView()
}
