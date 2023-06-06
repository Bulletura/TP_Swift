//
//  MapSearch.swift
//  App_Swift
//
//  Created by digital on 22/05/2023.
//

import SwiftUI
import MapKit
struct Place: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}
