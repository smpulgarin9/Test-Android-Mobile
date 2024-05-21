//
//  ContentView.swift
//  test-ios-sara
//
//  Created by Sara Pulgarin on 20/05/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var apiManager = APIManager()
    
    @State private var isFilterDrawerOpen: Bool = false
    @State private var searchTerm: String?
    @State private var filterCriteria: FilterCriteria?
    
    var body: some View {
        ZStack {
            NavigationView {
                MovieListView(
                    popularMovies: (apiManager.popularMovies ?? []),
                    topRatedMovies: (apiManager.topRatedMovies ?? []),
                    searchResults: (apiManager.searchResults ?? []),
                    filterCriteria: filterCriteria
                )
                .navigationBarItems(leading: filterButton)
            }
            FilterDrawer(
                isOpen: isFilterDrawerOpen,
                movieList: (apiManager.popularMovies ?? []) + (apiManager.topRatedMovies ?? []),
                onApplyFilter: { filter in
                    filterCriteria = filter
                    isFilterDrawerOpen = false
                },
                onSearch: { term in
                    if let term = term, !term.isEmpty {
                        apiManager.fetchMovies(from: .search, searchTerm: term)
                    } else {
                        apiManager.searchResults = nil
                    }
                    isFilterDrawerOpen.toggle()
                }
            )
        }
        .background(Color.white)
    }
    
    private var filterButton: some View {
        Button(action: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                isFilterDrawerOpen.toggle()
            }
        }) {
            HStack {
                Image(systemName: "line.horizontal.3.decrease.circle")
                Text("Filter")
            }
        }
    }
}

#Preview {
    ContentView()
}
