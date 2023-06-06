//
//  Api.swift
//  App_Swift
//
//  Created by digital on 17/04/2023.
//

import Foundation

let apiKey = "56e674cbce6fa4a0cebcc75917bb8925"

let url = URL(string: "https://api.themoviedb.org/3/movie/100?api_key=\(apiKey)&language=fr-FR")!

let fetchGenreUrl = "https://api.themoviedb.org/3/genre/movie/list?api_key=\(apiKey)&language=fr-FR"
let fetchJohnnyMoviesUrl = "https://api.themoviedb.org/3/list/6656?api_key=\(apiKey)&language=fr-FR"
let fetchDisneyMoviesUrl = "https://api.themoviedb.org/3/discover/movie?api_key=56e674cbce6fa4a0cebcc75917bb8925&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_companies=6125&with_watch_monetization_types=flatrate&language=fr-FR"

let imagesUrlPrefix = "https://image.tmdb.org/t/p/w500"
let backdropImagesUrlPrefix = "https://image.tmdb.org/t/p/original"


class FetchMovies: ObservableObject {
    @Published var movies = [MovieFromListDto]()
    @Published var genres = [GenreDto]()
    @Published var selectedMovie: MovieDto?
    @Published var selectedGenreId: Int?
    var movieStore = MovieStore()
    
    func getMovie(movieId: Int) {
        Task { @MainActor in
            self.selectedMovie = await movieStore.getMovie(movieId: movieId)
        }
    }
    func getMoviesByGenre(genreId: Int, page: Int) {
        Task { @MainActor in
            let moviesData = await movieStore.getMoviesByGenre(genreId: genreId, page: page)
            guard let moviesData = moviesData else {
                return
            }
            self.movies += moviesData
        }
    }
    func getMoviesByCategory(categoryName: String, page: Int) {
        Task { @MainActor in
            let movies = await movieStore.getMoviesByCategory(categoryName: categoryName, page: page)
            guard let movies = movies else {
                return
            }
            self.movies += movies.items
        }
    }
    func setGenreId(genreId: Int) {
        self.selectedGenreId = genreId
    }
    func getGenres() {
        Task { @MainActor in
            guard let genres = await movieStore.getGenres() else {
                return
            }
            self.genres = genres
        }
    }
}

func findTrailer(videos: VideosDto) -> VideoDto?{
    let officialTrailers = videos.results.filter({ video in
        if(video.site == "YouTube" && video.type == "Trailer" && video.official){
            return true
        }
        return false
    })
    return officialTrailers.max { $0.published_at > $1.published_at }
}
