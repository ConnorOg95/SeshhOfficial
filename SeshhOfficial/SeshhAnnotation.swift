//
//  SeshhAnnotation.swift
//  SeshhOfficial
//
//  Created by User on 13/05/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import Foundation
import MapKit

class SeshhAnnotation: NSObject, MKAnnotation {
    
    var coordinate = CLLocationCoordinate2D()
    var postId: String
    
    init(coordinate: CLLocationCoordinate2D, postId: String) {
        self.coordinate = coordinate
        self.postId = postId
    }
    
    
    
}
