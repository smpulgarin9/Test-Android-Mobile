//
//  MovieListView.swift
//  test-ios-sara
//
//  Created by Sara Pulgarin on 20/05/24.
//

import SwiftUI

struct MovieListView: View {
    @State private var selectedCategory: String = "Popular"
    var popularMovies: [Movie] = []
    var topRatedMovies: [Movie] = []
    var searchResults: [Movie] = []
    var categories = ["Popular", "TopRated"]
    var filterCriteria: FilterCriteria?

    var body: some View {
        VStack {
            Picker("", selection: $selectedCategory) {
                ForEach(categories, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            List(filteredAndSortedMovies()) { movie in
                Text(movie.title)
            }
        }
    }

    private func filteredAndSortedMovies() -> [Movie] {
        let movieList = moviesForSelectedCategory()
        return applyFilters(to: movieList)
    }

    private func moviesForSelectedCategory() -> [Movie] {
        if selectedCategory == "Popular" {
            return searchResults.isEmpty ? popularMovies : searchResults.sorted { $0.popularity > $1.popularity }
        } else {
            return searchResults.isEmpty ? topRatedMovies : searchResults.sorted { $0.voteAverage > $1.voteAverage }
        }
    }

    private func applyFilters(to movies: [Movie]) -> [Movie] {
        guard let filterOptions = filterCriteria else { return movies }

        var filteredMovies = movies

        if !filterOptions.includeAdultContent {
            filteredMovies = filteredMovies.filter { !$0.adult }
        }

        if let language = filterOptions.language, !language.isEmpty {
            filteredMovies = filteredMovies.filter { $0.originalLanguage == language }
        }

        if let range = filterOptions.rating, range > 0 {
            filteredMovies = filteredMovies.filter { $0.voteAverage < range }
        }

        return filteredMovies
    }
}

#Preview {
    MovieListView()
}
