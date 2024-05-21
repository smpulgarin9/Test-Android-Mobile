//
//  APIManager.swift
//  test-ios-sara
//
//  Created by Sara Pulgarin on 20/05/24.
//

import Foundation

enum Endpoint: String {
    case popular = "https://api.themoviedb.org/3/movie/popular"
    case topRated = "https://api.themoviedb.org/3/movie/top_rated"
    case search = "https://api.themoviedb.org/3/search/movie"
}

struct Movie: Codable, Identifiable {
    let id: Int
    let originalLanguage: String
    let title: String
    let popularity: Double
    let voteAverage: Double
    let adult: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case originalLanguage = "original_language"
        case title
        case popularity
        case voteAverage = "vote_average"
        case adult
    }
}

struct MovieListResponse: Codable {
    let results: [Movie]
}

class APIManager: ObservableObject {
    @Published var popularMovies: [Movie]?
    @Published var topRatedMovies: [Movie]?
    @Published var searchResults: [Movie]?
    
    private let apiKey = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiOTI5YThmM2U3ZTk4MGJlOGRmZDNlMGUwZTJhMjgxOCIsInN1YiI6IjY2NGI3MTVmYTg3YjJlYTBhMzY2NTMxNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ._R8oyppBUMufP1jknZ22k3zOZ5cS4r-1_ZLWOSmcVko"
    
    init() {
        fetchMovies(from: .popular)
        fetchMovies(from: .topRated)
    }
    
    func fetchMovies(from endpoint: Endpoint, searchTerm: String? = nil) {
        var components = URLComponents(string: endpoint.rawValue)!
        components.queryItems = [
            URLQueryItem(name: "query", value: searchTerm),
            URLQueryItem(name: "include_adult", value: "true"),
            URLQueryItem(name: "page", value: "1")
        ].filter { $0.value != nil } // Filter out nil values

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Error: No data received")
                return
            }
            
            do {
                let movieListResponse = try JSONDecoder().decode(MovieListResponse.self, from: data)
                DispatchQueue.main.async {
                    switch endpoint {
                    case .popular:
                        self.popularMovies = movieListResponse.results
                    case .topRated:
                        self.topRatedMovies = movieListResponse.results
                    case .search:
                        self.searchResults = movieListResponse.results
                    }
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
            }
        }.resume()
    }
}
