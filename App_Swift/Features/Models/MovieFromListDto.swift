//
//  MovieFromListDtoModel.swift
//  App_Swift
//
//  Created by digital on 23/05/2023.
//

import SwiftUI


struct MovieFromListDto: Codable, Hashable {
    var id: Int
    var title: String?
    var overview: String?
    var release_date: String?
    var tagline: String?
    var poster_path: String?
    var backdrop_path: String?
    var adult: Bool
    var genre_ids: [Int] = []
}
