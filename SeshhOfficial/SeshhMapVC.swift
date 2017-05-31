//
//  SeshhMapVC.swift
//  SeshhOfficial
//
//  Created by User on 02/03/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import UIKit
import MapKit

class SeshhMapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var mapHasCentredOnce = false
//    var user: User!
//    let profileImg: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self

    }
    
//    func fetchUser() {
//        Api.user.observeCurrentUser { (user) in
//            self.user = user
//        }
//    }
    
    // ENSURES CURRENT LOCATION MUST BE AUTHORISED WHEN IN USE
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationAuthStatus()
    }
    
    // CHANGED AUTHORISATION STATUS TO TRUE
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
    }
    
    // THIS CENTRES MAP ON CURRENT LOCATION
    func centreMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // THIS CENTRES MAP ON CURRENT LOCATION WHEN MAP OPENS
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        if let loc = userLocation.location {
            if !mapHasCentredOnce {
                centreMapOnLocation(location: loc)
                mapHasCentredOnce = true
            }
        }
    }
    
    // THIS IS ANNOTATION FOR CURRENT LOCATION & SESHH MARKER
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annoIdentifier = "Seshh"
        var annotationView: MKAnnotationView?
        
        if annotation.isKind(of: MKUserLocation.self) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
            annotationView?.image = UIImage(named: "placeholderImg")
            annotationView?.contentMode = UIViewContentMode.scaleAspectFit
            annotationView?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            annotationView?.layer.cornerRadius = 20
            annotationView?.clipsToBounds = true
            annotationView?.layer.borderColor = UIColor(red: 60/255, green: 204/255, blue: 252/255, alpha: 1).cgColor
            annotationView?.layer.borderWidth = 2
        } else if let deqAnno = mapView.dequeueReusableAnnotationView(withIdentifier: annoIdentifier) {
            annotationView = deqAnno
            annotationView?.annotation = annotation
        } else {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annoIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = av
        }
        
        // SESHH LOCATION MAP MARKER ANNOTATION
        if let annotationView = annotationView, let _ = annotation as? PinAnnotation {
            
            annotationView.canShowCallout = false
            annotationView.image = UIImage(named: "Drinks")
            annotationView.contentMode = UIViewContentMode.scaleAspectFit
            annotationView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            annotationView.layer.cornerRadius = 20
            annotationView.clipsToBounds = true
            annotationView.layer.borderColor = UIColor(red: 60/255, green: 204/255, blue: 252/255, alpha: 1).cgColor
            annotationView.layer.borderWidth = 2
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        let loc = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        Api.location.showSeshhsOnMap(location: loc, mapView: mapView)
    }



}
