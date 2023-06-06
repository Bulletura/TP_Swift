//
//  ContentView.swift
//  App_Swift
//
//  Created by digital on 04/04/2023.
//

import SwiftUI
struct MainContentView: View {
    @State private var GoToDesc: Bool = false
    @State private var GoToMap: Bool = false
    @State private var clickedMovie: MovieDto?
    @State private var selectedGenre: GenreDto?
    @StateObject var callMovies = FetchMovies()
    let imagesUrlPrefix = "https://image.tmdb.org/t/p/w500"
    var body: some View {
        NavigationStack {
            VStack {
                Button {
                    GoToMap = true
                } label: {
                    Image(systemName: "location.circle")
                }.navigationDestination(isPresented: $GoToMap, destination: {
                    ParentMapView()
                })
                GenreHorizontalListView(callMovies: callMovies, selectedGenre: $selectedGenre)
                ScrollView{
                    Spacer(minLength: 50)
                    HorizontalScrollView(genre: $selectedGenre, categorieTitle: "Populaire")
                    HorizontalScrollView(genre: $selectedGenre, categorieTitle: "Mieux notés")
                    HorizontalScrollView(genre: $selectedGenre, categorieTitle: "Tendances")
                    HorizontalScrollView(genre: $selectedGenre, categorieTitle: "Johnny")
                }
                
            }
        }
    }
}
    
