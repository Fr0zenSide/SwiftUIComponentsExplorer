//
//  SearchView.swift
//  ViewThatFits
//
//  Created by Jeoffrey Thirot on 09/04/2024.
//

import SwiftUI


extension SearchView {
    fileprivate enum TestCases: Int, Identifiable, CustomStringConvertible, CaseIterable {
        var id: Int { rawValue }
        
        case first, second, third, fourth//, fifth, sixth, seventh, eighth, ninth
        
        var description: String {
            let index = Self.allCases.firstIndex(of: self)!
            return RomanNumeralFormatter.convert(for: index + 1)
        }
    }
}

struct SearchView: View {
    
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
        }
    }
    
    @State private var searchText = ""
    @State private var searchIsActive = false
    
    @ViewBuilder
    var testCase1: some View {
        Text("Searching for \(searchText); isActive? \(searchIsActive ? "Yes" : "No")")
            .navigationTitle("Searchable Example")
            .searchable(text: $searchText,
                        isPresented: $searchIsActive,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "Looking for...")
    }
    
    
    // MARK: - Search with suggestion (broken UI)
    
    let names = ["Holly", "Josh", "Rhonda", "Ted"]
    @State private var searchText2 = ""
    
    @ViewBuilder
    var testCase2: some View {
        List {
            ForEach(searchResults, id: \.self) { name in
                NavigationLink {
                    Text(name)
                } label: {
                    Text(name)
                }
            }
        }
        .navigationTitle("Contacts")
        .searchable(text: $searchText2) {
            VStack {
                ForEach(searchResults, id: \.self) { result in
                    Text("Are you looking for \(result)?").searchCompletion(result)
                }
            }
            .frame(alignment: .leading)
        }
    }
    
    var searchResults: [String] {
        if searchText2.isEmpty {
            return names
        } else {
            return names.filter { $0.contains(searchText2) }
        }
    }
    
    
    // MARK: - Search with Scope
    
    struct Message: Identifiable, Codable {
        let id: Int
        var user: String
        var text: String
    }

    enum SearchScope: String, CaseIterable {
        case inbox, favorites
    }

    @State private var messages = [Message]()
    
    @State private var searchText3 = ""
    @State private var searchScope = SearchScope.inbox
    
    @ViewBuilder
    var testCase3: some View {
        List {
            ForEach(filteredMessages) { message in
                VStack(alignment: .leading) {
                    Text(message.user)
                        .font(.headline)
                    
                    Text(message.text)
                }
            }
        }
        .navigationTitle("Messages")
        
        .searchable(text: $searchText3)
        .searchScopes($searchScope) {
            ForEach(SearchScope.allCases, id: \.self) { scope in
                Text(scope.rawValue.capitalized)
            }
        }
        .onAppear(perform: runSearch)
        .onSubmit(of: .search, runSearch)
        .onChange(of: searchScope) { _, _ in runSearch() }
    }
    
    var filteredMessages: [Message] {
        if searchText3.isEmpty {
            return messages
        } else {
            return messages.filter { $0.text.localizedCaseInsensitiveContains(searchText3) }
        }
    }
    
    func runSearch() {
        Task {
            guard let url = URL(string: "https://hws.dev/\(searchScope.rawValue).json") else { return }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            messages = try JSONDecoder().decode([Message].self, from: data)
        }
    }
    
    
    // MARK: -  Search with Token (looks like tags) // it doesn't work for token display
    
    // Holds one uniquely identifiable movie.
    struct Movie: Identifiable {
        var id = UUID()
        var name: String
        var genre: String
    }

    // Holds one token that we want the user to filter by. This *must* conform to Identifiable.
    struct Token: Identifiable {
        var id: String { name }
        var name: String
    }
    
    // Whatever text the user has typed so far.
    @State private var searchText4 = ""
    
    // All possible tokens we want to show to the user.
    let allTokens = [
        Token(name: "Action"),
        Token(name: "Comedy"),
        Token(name: "Drama"),
        Token(name: "Family"),
        Token(name: "Sci-Fi")
    ]
    
    // The list of tokens the user currently has selected.
    @State private var currentTokens = [Token]()
    
    // The list of tokens we want to show to the user right now. Activates token selection only when searchText starts with #.
    var suggestedTokens: [Token] {
        let hasHtag = searchText4.starts(with: "#") { char, seq in
//            print("char: \(char); seq: \(seq)")
            return seq == char
        }
        
        return hasHtag ? allTokens : []
    }
    
    // Some data to show and filter by.
    let movies = [
        Movie(name: "Avatar", genre: "Sci-Fi"),
        Movie(name: "Inception", genre: "Sci-Fi"),
        Movie(name: "Love Actually", genre: "Comedy"),
        Movie(name: "Paddington", genre: "Family")
    ]
    
    // The real work: filter all the movies based on search text or tokens.
    var searchResults2: [Movie] {
        // trim whitespace
        let trimmedSearchText = searchText4.trimmingCharacters(in: .whitespaces)
        
        return movies.filter { movie in
            if searchText4.isEmpty == false {
                // If we have search text, make sure this item matches.
                if movie.name.localizedCaseInsensitiveContains(trimmedSearchText) == false {
                    return false
                }
            }
            
            if currentTokens.isEmpty == false {
                // If we have search tokens, loop through them all to make sure one of them matches our movie.
                for token in currentTokens {
                    if token.name.localizedCaseInsensitiveContains(movie.genre) {
                        return true
                    }
                }
                
                // This movie does *not* match any of our tokens, so it shouldn't be sent back.
                return false
            }
            
            // If we're still here then the movie should be included.
            return true
        }
    }
    
    @ViewBuilder
    var testCase4: some View {
        List(searchResults2) { movie in
            Text(movie.name)
        }
        .navigationTitle("Movies+")
        .searchable(text: $searchText4, tokens: $currentTokens, suggestedTokens: .constant(suggestedTokens), prompt: Text("Type to filter, or use # for tags")) { token in
            Text(token.name)
                .offset(y: 100)
        }
    }
    
    @ViewBuilder
    var testCase5: some View {
        EmptyView()
    }
    
    @ViewBuilder
    var testCase6: some View {
        EmptyView()
    }
    
    @ViewBuilder
    var testCase7: some View {
        EmptyView()
    }
    
    @ViewBuilder
    var testCase8: some View {
        EmptyView()
    }
    
    @ViewBuilder
    var testCase9: some View {
        EmptyView()
    }
}


#Preview {
    NavigationStack {
        SearchView()
    }
}
