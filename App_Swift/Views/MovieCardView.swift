//
//  MovieCardView.swift
//  App_Swift
//
//  Created by digital on 18/04/2023.
//

import SwiftUI
import CachedAsyncImage

struct MovieCardView: View {
    let imageUrl: URL
    let movie: MovieFromListDto
    @Binding var GoToDesc: Bool
    let callMovies: FetchMovies
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(width: 130, height: 200)
            .padding(.vertical, 10)
            .shadow(radius: 3, x: -2, y: 5)
            .foregroundColor(Color.gray)
            .overlay {
                Button(action: {
                    GoToDesc = true
                    Task {
                        print(movie.id)
                        callMovies.getMovie(movieId: movie.id)
                    }
                }) {
                    CachedAsyncImage(url: imageUrl, scale: 2) { phase in // 1
                        if let image = phase.image { // 2
                            // if the image is valid
                            image
                                .resizable()
                                .blur(radius: movie.adult ? 20 : 0)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 130, height: 200)
                                .clipped()
                                .cornerRadius(5)
                        } else if phase.error != nil { // 3
                            // some kind of error appears
                            Text("Image not found")
                                .foregroundColor(Color.white)
                                .bold()
                                .font(.title)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 10)
                            
                        } else { // 4
                            // showing progress view as placeholder
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                                .font(.largeTitle)
                        }
                    }
                }
            }
    }
}
