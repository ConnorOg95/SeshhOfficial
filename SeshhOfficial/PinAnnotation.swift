//
//  PinAnnotation.swift
//  SeshhOfficial
//
//  Created by User on 12/05/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import Foundation
import MapKit

let seshhCategory = ["Drinks", "Active", "Recreational", "Sports", "Entertainment", "Music"]

class PinAnnotation: NSObject, MKAnnotation {
    
    
    
    var coordinate = CLLocationCoordinate2D()
    var seshhNumber: Int
    var seshhName: String
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D, seshhNumber: Int) {
        self.coordinate = coordinate
        self.seshhNumber = seshhNumber
        self.seshhName = seshhCategory[seshhNumber].capitalized
        self.title = self.seshhName
    }
}
