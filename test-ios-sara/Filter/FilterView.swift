import SwiftUI

struct FilterCriteria {
    var language: String? = nil
    var rating: Double? = nil
    var includeAdultContent: Bool = true
}

struct FilterView: View {
    @State private var searchTerm = ""
    @State private var selectedLanguage: String = ""
    @State private var includeAdultContent: Bool = true
    @State private var selectedRating: Double = 0.0
    var movieList: [Movie] = []
    var onApplyFilter: (_ filterCriteria: FilterCriteria?) -> Void
    var onSearch: (_ searchTerm: String?) -> Void

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: { onSearch(nil) }) { Image(systemName: "xmark") }
                .padding(.vertical)
            }
            TextField("Search", text: $searchTerm)
                .disableAutocorrection(true)
                .padding(10)
                .border(Color.gray)
                .onSubmit { onSearch(searchTerm) }

            // The first request not containt adult item, the search request contains that content
            let displayAdultToggle = !movieList.allSatisfy { !$0.adult } || !searchTerm.isEmpty
            
            if displayAdultToggle {
                HStack {
                    Toggle(isOn: $includeAdultContent) {
                        Text("Include Adult: ").bold()
                    }.tint(Color.green)
                    Spacer()
                }
                .padding(.vertical)
            }

            HStack {
                Text("Original Language: ").bold().fixedSize()
                let uniqueLanguages = Dictionary(grouping: movieList) { $0.originalLanguage }
                Picker("Language", selection: $selectedLanguage) {
                    ForEach(uniqueLanguages.keys.sorted(), id: \.self) { language in
                        Text(language).padding()
                    }
                }.pickerStyle(.menu)
                Spacer()
            }

            VStack {
                HStack {
                    Text("Vote Average: ").bold()
                    Text("\(selectedRating)")
                    Spacer()
                }
                let ratingRange = movieList.map { $0.voteAverage }.sorted()
                HStack {
                    Slider(
                        value: $selectedRating,
                        in: (ratingRange.first ?? 0.0)...(ratingRange.last ?? 0.0)
                    )
                }
                HStack {
                    Text("\(Int(ratingRange.first ?? 0.0))")
                    Spacer()
                    Text("\(Int(ratingRange.last ?? 0.0))")
                }
            }
            .padding(.top)

            HStack {
                Spacer()
                
                Button("Clear") {
                    searchTerm = ""
                    selectedLanguage = ""
                    selectedRating = 0.0
                    includeAdultContent = true
                    onSearch(nil)
                    onApplyFilter(nil)
                }
                .tint(Color.accentColor)
                .font(.title2)
                .padding()
                
                Button("Filter") {
                    if !searchTerm.isEmpty {
                        onSearch(searchTerm)
                    }
                    onApplyFilter(FilterCriteria(
                        language: selectedLanguage,
                        rating: selectedRating,
                        includeAdultContent: includeAdultContent
                    ))
                }
                .tint(Color.accentColor)
                .font(.title2)
                .padding()
            }
            Spacer()
        }
        .padding(.horizontal)
        .navigationTitle("Filter")
        .background(Color.white)
        .tint(Color.black)
    }
}

#Preview {
    FilterView(onApplyFilter: { _ in }, onSearch: { _ in })
}
