//
//  utils.swift
//  App_Swift
//
//  Created by digital on 22/05/2023.
//

import SwiftUI

extension Color{
    init(id: Int){
        let baseNumber: Double = Double(id + 2)
        let r : Double = (baseNumber * baseNumber).truncatingRemainder(dividingBy: 255.0)
        let g : Double = (r * baseNumber).truncatingRemainder(dividingBy: 255.0)
        let b : Double = (g * baseNumber).truncatingRemainder(dividingBy: 255.0)
        self.init(red: Double(r/255.0), green: Double(g/255.0), blue: Double(b/255.0))
    }
}

