//
//  HorizontalScrollView.swift
//  App_Swift
//
//  Created by digital on 18/04/2023.
//

import SwiftUI

struct HorizontalScrollView: View {
    @Binding var genre: GenreDto?
    let categorieTitle: String
    @State var page: Int = 1
    @StateObject var callMovies = FetchMovies()
    @State private var GoToDesc: Bool = false
    var body: some View {
        VStack(alignment: .leading){
            Text(categorieTitle)
                .bold()
                .font(.system(size: 26))
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 15, content: {
                    ForEach(callMovies.movies, id: \.title){ movie in
                        if let imageUrl = movie.poster_path {
                            let url = URL(string: imagesUrlPrefix+imageUrl)!
                            MovieCardView(imageUrl: url, movie: movie, GoToDesc: $GoToDesc, callMovies: callMovies)
                                .onAppear{
                                if movie == self.callMovies.movies.last {
                                    page += 1
                                    Task {
                                        print(categorieTitle)
                                        var categoryName: String = ""
                                        switch (categorieTitle) {
                                            case "Populaire":
                                                categoryName = "popular"
                                            case "Mieux notés":
                                                categoryName = "top_rated"
                                            case "Tendances":
                                                categoryName = "trending"
                                            case "Johnny":
                                                categoryName = "johnny"
                                            default: categoryName = "popular"
                                        }
                                        callMovies.getMoviesByCategory(categoryName: categoryName, page: page)
                                    }
                                }
                            }
                        }
                    }
                })
            }
            .frame(height: 200)
            .transition(.move(edge: .bottom))
            .padding(.bottom, 20)
            .navigationDestination(isPresented: $GoToDesc){
                if let movie = callMovies.selectedMovie {
                    DescriptionView(movie: movie, trailer: findTrailer(videos: movie.videos))
                }
            }
        }
        .padding(.leading, 15)
        .task {
            if let genreId = genre?.id {
               callMovies.getMoviesByGenre(genreId: genreId, page: 1)
            }
            
            var categoryName: String = ""
            switch (categorieTitle) {
                case "Populaire":
                    categoryName = "popular"
                case "Mieux notés":
                    categoryName = "top_rated"
                case "Tendances":
                    categoryName = "trending"
                case "Johnny":
                    categoryName = "johnny"
                default: categoryName = "popular"
            }
            callMovies.getMoviesByCategory(categoryName: categoryName, page: page)
        }
    }
}
