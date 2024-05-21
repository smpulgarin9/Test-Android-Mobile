//
//  FilterDrawer.swift
//  test-ios-sara
//
//  Created by Sara Pulgarin on 20/05/24.
//

import SwiftUI

struct FilterDrawer: View {
    private let drawerWidth = UIScreen.main.bounds.width - 100
    var isOpen: Bool = false
    var movieList: [Movie] = []
    var onApplyFilter: (_ filterCriteria: FilterCriteria?) -> Void
    var onSearch: (_ searchTerm: String?) -> Void
    
    var body: some View {
        HStack {
            FilterView(movieList: movieList, onApplyFilter: onApplyFilter, onSearch: onSearch)
                .frame(width: drawerWidth)
                .offset(x: isOpen ? 0 : -drawerWidth)
                .animation(.easeInOut, value: isOpen)
            Spacer()
        }
    }
}

#Preview {
    FilterDrawer(onApplyFilter: { _ in }, onSearch: { _ in })
}
