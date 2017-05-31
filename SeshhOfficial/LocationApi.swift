//
//  LocationApi.swift
//  SeshhOfficial
//
//  Created by User on 12/05/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import Foundation
import MapKit
import Firebase

class LocationApi {
    
    var currentDate: String?
    let date = Date()
    let formatter = DateFormatter()
    
    func setCurrentDate() {
        formatter.dateFormat = "dd/MM/YYYY"
        currentDate = formatter.string(from: date)
    }
    
    var REF_POST_LOCATIONS = FIRDatabase.database().reference().child("seshhLocations") //CHANGE TO CURRENTDATE STRING
    
    func showSeshhsOnMap(location: CLLocation, mapView: MKMapView) {
        setCurrentDate()
        let geoFireRef = REF_POST_LOCATIONS.child(currentDate!)
        let geoFire = GeoFire(firebaseRef: geoFireRef)
        let circleQuery = geoFire?.query(at: location, withRadius: 2.5)
        
        _ = circleQuery?.observe(GFEventType.keyEntered, with: { (key, location) in
            
            if let key = key, let location = location {
                print("CONNOR: LOCATION KEY - \(key)")
                let anno = PinAnnotation(coordinate: location.coordinate, seshhNumber: 2)
                mapView.addAnnotation(anno)
            }
        })
    }
    

}
