//
//  DescriptionView.swift
//  App_Swift
//
//  Created by digital on 17/04/2023.
//

import SwiftUI

struct DescriptionView: View{
    @StateObject var callMovies = FetchMovies()
    let movie: MovieDto
    let imagesUrlPrefix = "https://image.tmdb.org/t/p/w500"
    let trailer: VideoDto?
    @State private var showSheet: Bool = false
    @State private var sheetSize: PresentationDetent = .medium
    var body: some View {
        VStack(spacing: -600){
            AsyncImage(url: URL(string:imagesUrlPrefix+(movie.poster_path ?? ""))!) { phase in // 1
                if let image = phase.image { // 2
                    // if the image is valid
                    image
                        .resizable()
                        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 600)
                        .mask(LinearGradient(gradient: Gradient(colors: [.black, .black, .clear]), startPoint: .top, endPoint: .bottom))
                        .edgesIgnoringSafeArea(.all)
                        .aspectRatio(contentMode: .fill)
                } else if phase.error != nil { // 3
                    // some kind of error appears
                    Text("404! \n No image available 😢")
                        .bold()
                        .font(.title)
                        .multilineTextAlignment(.center)
                    
                } else { // 4
                    // showing progress view as placeholder
                    ProgressView()
                        .font(.largeTitle)
                }
            }
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Button {
                        showSheet.toggle()
                    } label: {
                        Image(systemName: "film")
                    }

                    Text("Synopsis :\n" + (movie.overview ?? ""))
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.system(size: 16))
                        .foregroundColor(Color.white)
                    if let tagline = movie.tagline {
                        if tagline != "" {
                            Text("Sous-Titre :\n" + tagline)
                                .foregroundColor(Color.white)
                        }
                    }
                    Text("Date de sortie : " + (movie.formatted_release_date ?? ""))
                        .foregroundColor(Color.white)
                    Text("Duree du film : " + (movie.parsedRuntime ?? ""))
                        .foregroundColor(Color.white)
                    Text("Genres :")
                        .foregroundColor(Color.white)
                    ForEach(0..<movie.genres.count, id: \.self){ i in
                        Text("\(i+1). " + (callMovies.genres.first(where: { $0.id == callMovies.genres[i].id})?.name ?? ""))
                            .foregroundColor(Color.white)
                    }
                }
                .padding(EdgeInsets(top: 400, leading: 0, bottom: 0, trailing: 0))
                .frame(maxWidth: .infinity)
                .offset(y: 0)
                .task {
                    callMovies.getGenres()
                    callMovies.getMovie(movieId: movie.id)
                }
            }
            .offset(y: 0)
        }
        .background(.black)
        .sheet(isPresented: $showSheet, content: {
            NavigationView {
                VStack() {
                    TrailerSheetView(movie: movie, trailer: findTrailer(videos: movie.videos), sheetSize: $sheetSize)
                }.padding(.leading, 10).padding(.trailing, 10)
            }.frame(height: 9999).padding(.top, 75)
            Color.white
                .presentationDetents([sheetSize]).onDisappear() {
                    sheetSize = .medium
                }
        })
    }
}
