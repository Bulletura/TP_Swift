//
//  GenreVerticalListView.swift
//  App_Swift
//
//  Created by digital on 18/04/2023.
//

import SwiftUI

struct GenreHorizontalListView: View {
    @StateObject var callMovies = FetchMovies()
    @Binding var selectedGenre: GenreDto?
    @State private var GoToFilmByGenre: Bool = false
    var body: some View {
        VStack(alignment: .leading){
            Text("Genres")
                .bold()
                .font(.system(size: 26))
                .padding(.leading, 15)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Spacer(minLength: 15)
                    ForEach(callMovies.genres, id: \.self){ genre in
                        GenreButtonView(genre: genre, selectedGenre: $selectedGenre, GoToFilmByGenre: $GoToFilmByGenre)
                    }
                }
                .navigationDestination(isPresented: $GoToFilmByGenre){
                    if let genreName = selectedGenre?.name {
                        GenreMoviesGridView(moviesListName: nil, genre: $selectedGenre, categorieTitle: genreName)
                    }
                }
            }
            .transition(.move(edge: .bottom))
            .task {
                callMovies.getGenres()
            }
        }
    }
}
