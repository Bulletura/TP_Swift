//
//  GenreMoviesGridView.swift
//  App_Swift
//
//  Created by digital on 18/04/2023.
//

import SwiftUI

struct GenreMoviesGridView: View {
    let moviesListName: String?
    @Binding var genre: GenreDto?
    let categorieTitle: String
    @State var page: Int = 1
    @StateObject var callMovies = FetchMovies()
    @State private var GoToDesc: Bool = false
    var body: some View {
        VStack {
            
            Text(categorieTitle)
                .bold()
                .font(.system(size: 26))
            ScrollView {
                LazyVGrid(columns: [GridItem(), GridItem(), GridItem()], alignment: .leading){
                    ForEach(callMovies.movies, id: \.self){ movie in
                        if let imageUrl = movie.poster_path {
                            let url = URL(string: imagesUrlPrefix+imageUrl)!
                            GenreMovieCardView(imageUrl: url, movie: movie, GoToDesc: $GoToDesc, callMovies: callMovies)
                                .onAppear{
                                    if movie == self.callMovies.movies.last {
                                        page += 1
                                        Task {
                                            if let genreId = genre?.id {
                                                callMovies.getMoviesByGenre(genreId: genreId, page: page)
                                            }
                                        }
                                        print("last")
                                    }
                                }
                        }
                    }
                }
                .navigationDestination(isPresented: $GoToDesc){
                    if let movie = callMovies.selectedMovie {
                        DescriptionView(movie: movie, trailer: findTrailer(videos: movie.videos))
                    }
                }
                .padding(.horizontal, 10)
                .task {
                    if let genreId = genre?.id {
                        callMovies.getMoviesByGenre(genreId: genreId, page: page)
                    }
                    
                    if let moviesListName = moviesListName {
                        if moviesListName == "Disney" {
                        }
                    }
                }
            }
        }
    }
}
