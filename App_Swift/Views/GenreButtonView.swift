//
//  GenreButtonView.swift
//  App_Swift
//
//  Created by digital on 18/04/2023.
//

import SwiftUI
import Foundation

struct GenreButtonView: View {
    var genre: GenreDto
    @Binding var selectedGenre: GenreDto?
    @Binding var GoToFilmByGenre: Bool
    var body: some View {
        
        Button(action: {
            selectedGenre = genre
            GoToFilmByGenre = true
        }, label: {
            Text(genre.name)
                .foregroundColor(Color.white)
                .bold()
                .font(.system(size: 16))
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(){
                    Capsule()
                        .foregroundColor(Color(id: genre.id))
                }
        })
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
