//
//  SecondViewController.swift
//  Explore@SMU
//
//  Created by ch484-mac5 on 4/28/15.
//  Copyright (c) 2015 Team B.E.N. All rights reserved.
//

import UIKit
import MapKit

class SearchViewController: UIViewController, MKMapViewDelegate {

    
    let regionRadius: CLLocationDistance = 50
    var place: Place = Place(title: "nil", area: "nil", coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.showsUserLocation = true
        
        self.mapView.setUserTrackingMode(MKUserTrackingMode.FollowWithHeading, animated: true)
         
        self.mapView.scrollEnabled = false
        
        self.mapView.rotateEnabled = false
        
        self.mapView.centerCoordinate = place.coordinate
        
        let initialLocation = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        centerMapOnLocation(initialLocation)
        
        self.mapView.addAnnotation(place)
        
        self.mapView.delegate = self
    }
    
    func centerMapOnLocation(location: CLLocation){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius*2.0, regionRadius*2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation
        userLocation: MKUserLocation!) {
            //mapView.centerCoordinate = userLocation.location.coordinate
            self.mapView.setUserTrackingMode(MKUserTrackingMode.FollowWithHeading, animated: true)
    }
    
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? Place {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
            }
            
            return view
        }
        
        return nil
    }

}

