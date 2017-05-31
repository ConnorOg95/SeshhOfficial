//
//  PostSeshh3VC.swift
//  SeshhOfficial
//
//  Created by User on 27/04/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import UIKit
import MapKit

class PostSeshh3VC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var dropPinBtn: UIButton!
    
    var passedPostDict = [String: Any]()
    
    let locationManager = CLLocationManager()
    var mapHasCentredOnce = false
    var pinDropped = false
    var droppedPinLocation: CLLocation?
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        droppedPinLocation = nil
        mapView.delegate = self
       fetchUser()
    }
    
    func fetchUser() {
        Api.user.observeCurrentUser { (user) in
            self.user = user
        }
    }

    @IBAction func postButtonPressed(_ sender: Any) {
                ProgressHUD.show("Processing...", interaction: false)
        HelpService.uploadDataToServer(data: passedPostDict["data"] as! Data, videoUrl: passedPostDict["videoUrl"] as! URL?, ratio: passedPostDict["ratio"] as! CGFloat, title: passedPostDict["title"] as! String, description: passedPostDict["description"] as! String, startDate: passedPostDict["startDate"] as! String, endDate: passedPostDict["endDate"] as! String, category: passedPostDict["category"] as! String, location: droppedPinLocation!, onSuccess: {
            self.clearPost()
            self.tabBarController?.selectedIndex = 0
        })
    }
    
    func clearPost() {
        //CLEAR ALL INPUT FIELDS FOR POST
    }
    
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
            annotationView.image = UIImage(named: "likeSelected")
            annotationView.contentMode = UIViewContentMode.scaleAspectFit
            annotationView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        }
        return annotationView
    }
    
    
    @IBAction func handleTap(gestureReconizer: UITapGestureRecognizer) {
        if let mapView = self.view.viewWithTag(999) as? MKMapView {
     
            let allLocs = self.mapView.annotations
            self.mapView.removeAnnotations(allLocs)
            let location = gestureReconizer.location(in: mapView)
            let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
            
            let pinAnnotation = PinAnnotation(coordinate: coordinate, seshhNumber: 2)
            mapView.addAnnotation(pinAnnotation)
            
            let pinLatitude = pinAnnotation.coordinate.latitude
            let pinLongitude = pinAnnotation.coordinate.longitude
            droppedPinLocation = CLLocation(latitude: pinLatitude, longitude: pinLongitude)
            print("CONNOR: Pin Coordinate - \(droppedPinLocation)")
        }
    }
}
