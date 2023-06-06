//
//  VideoDtoDto.swift
//  App_Swift
//
//  Created by digital on 23/05/2023.
//

import SwiftUI

struct VideoDto: Codable, Hashable{
    var name: String
    var site: String
    var key: String
    var published_at: String
    var official: Bool
    var type: String
}
