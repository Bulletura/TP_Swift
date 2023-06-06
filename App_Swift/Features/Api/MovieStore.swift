//
//  MovieStore.swift
//  App_Swift
//
//  Created by digital on 05/06/2023.
//

import Foundation
extension URLComponents {
    static func buildURLApi(version: String = "3", api_key: String? = nil, path: String, parameters: [String: String]? = nil) -> URLComponents {
        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String else {
            return .init()
        }
        
        var urlComponent = URLComponents()
        var allParameters: [String:String] = [:]
        if let parameters = parameters {
            allParameters = parameters
        }
        urlComponent.scheme = "https"
        urlComponent.host = "api.themoviedb.org"
        urlComponent.path = "/" + version + "/" + path
        allParameters["language"] = Locale.preferredLanguages[0]
        if let api_key = api_key {
            allParameters["api_key"] = api_key
        } else {
            allParameters["api_key"] = apiKey
        }
        urlComponent.setQueryItems(with: allParameters)
        return urlComponent
    }
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}

struct MovieStore {
    func getMovie(movieId: Int) async -> MovieDto? {
        let parameters = ["append_to_response": "videos"]
    
        let urlComponent = URLComponents.buildURLApi(path: "movie/\(String(movieId))", parameters: parameters)
        guard let url = urlComponent.url else { return nil }
        
        do {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .full
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let (data, _) = try await URLSession.shared.data(from: url);
            let movie = try JSONDecoder().decode(MovieDto.self, from: data)
            let selectedMovie = await MainActor.run(body: {
                var selectedMovieTask = movie
                if let time = movie.runtime {
                    selectedMovieTask.parsedRuntime = formatter.string(from: TimeInterval(time*60))
                }
                if let release_date = movie.release_date {
                    let date = dateFormatter.date(from: release_date)
                    dateFormatter.dateFormat = "d MMMM yyyy"
                    selectedMovieTask.formatted_release_date = dateFormatter.string(from: date!)
                }
                return selectedMovieTask
            })
            return selectedMovie
        } catch {
            return nil
        }
    }
    
    func getMoviesByGenre(genreId: Int, page: Int) async -> [MovieFromListDto]? {
        print(Locale.preferredLanguages[0])
        let parameters = ["sort_by": "popularity.desc", "include_adult": "true", "include_video": "false", "page": String(page), "with_genres": String(genreId), "with_watch_monetization_type": "flatrate"]

        let urlComponent = URLComponents.buildURLApi(path: "discover/movie", parameters: parameters)
        guard let url = urlComponent.url else { return nil }
        
        do {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .full
            
            let (data, _) = try await URLSession.shared.data(from: url);
            let movies = try JSONDecoder().decode(MoviesDto.self, from: data)
            let moviesTask = await MainActor.run(body: {
                return movies.results
            })
            return moviesTask
        } catch {
            return nil
        }
    }
    func getMoviesByCategory(categoryName: String, page: Int) async -> MoviesFromListDto? {
        
        // Possible categoryName [popular, top_rated,  upcoming]
        let parameters = ["include_adult": "true", "page": String(page)]
        var path = "movie/" + categoryName
        if(categoryName == "trending") {
            path = categoryName + "/movie/day"
        } else if(categoryName == "johnny") {
            path = "list/6656"
        }
        let urlComponents = URLComponents.buildURLApi(path: path, parameters: parameters)
        print(urlComponents)
        guard let url = urlComponents.url else { return nil }
        
        do {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .full
            
            let (data, _) = try await URLSession.shared.data(from: url);
            var moviesTask: MoviesFromListDto
            if(categoryName == "johnny"){
                let movies = try JSONDecoder().decode(MoviesFromListDto.self, from: data)
                moviesTask = await MainActor.run (body:{
                    return MoviesFromListDto(items: movies.items)
                })
            } else {
                let movies = try JSONDecoder().decode(MoviesDto.self, from: data)
                moviesTask = await MainActor.run (body: {
                    return MoviesFromListDto(items: movies.results)
                })
            }
            return moviesTask
        } catch {
            return nil
        }
    }
    func getGenres() async -> [GenreDto]? {
        let urlComponent = URLComponents.buildURLApi(path: "genre/movie/list")
        guard let url = urlComponent.url else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let genres = try JSONDecoder().decode(GenresDto.self, from: data)
            let genresTask = await MainActor.run(body: {
                return genres.genres
            })
            return genresTask
        } catch {
            return nil
        }
    }
}
