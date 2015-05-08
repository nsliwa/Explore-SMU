//
//  FirstViewController.swift
//  Explore@SMU
//
//  Created by ch484-mac5 on 4/28/15.
//  Copyright (c) 2015 Team B.E.N. All rights reserved.
//

import UIKit
import MapKit

class ExploreViewController: UIViewController, MKMapViewDelegate {

    let regionRadius: CLLocationDistance = 50
    var places = [Place]()
    var annotate = [Place]()
    let minDistance = CLLocationDistance(100)
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //        self.tabBarItem = UITabBarItem(title: "Search", image: nil, tag: 2)
        //self.mapView.showsUserLocation = true
        
        let initialLocation = CLLocation(latitude: 32.8441, longitude: -96.7849)
        self.centerMapOnLocation(initialLocation)
        
        self.mapView.showsUserLocation = true
        self.mapView.setUserTrackingMode(MKUserTrackingMode.FollowWithHeading, animated: true)
        
        self.mapView.scrollEnabled = false
        
        self.mapView.rotateEnabled = false
        
        loadInitialData()
        
        mapView.delegate = self
    }
    
    func centerMapOnLocation(location: CLLocation){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius*2.0, regionRadius*2.0)
        mapView.setRegion(coordinateRegion, animated: true)
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
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation
        userLocation: MKUserLocation!) {
            //mapView.centerCoordinate = userLocation.location.coordinate
            self.mapView.setUserTrackingMode(MKUserTrackingMode.FollowWithHeading, animated: true)
            
            let userLoc = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            
            for annotated in annotate{
                
                let annotatedLocation = CLLocation(latitude: annotated.coordinate.latitude, longitude: annotated.coordinate.longitude)
                
                let dist = annotatedLocation.distanceFromLocation(userLoc)
                
                if dist > self.minDistance {
                    self.mapView.removeAnnotation(annotated);
                }
                
            }
            
            self.annotate.removeAll(keepCapacity: false)
            
            for place in places{
                
                let placeLocation = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                
                
                let dist = placeLocation.distanceFromLocation(userLoc)
                
                if dist <= self.minDistance {
                    self.annotate.append(place)
                }
                
            }
            
            self.mapView.addAnnotations(annotate)
            
    }
    
    
    func loadInitialData() {
        
        let fileName = NSBundle.mainBundle().pathForResource("SMUPlaces", ofType: "json");
        var readError : NSError?
        var data: NSData = NSData(contentsOfFile: fileName!, options: NSDataReadingOptions(0),
            error: &readError)!
        
        
        var error: NSError?
        let jsonObject: AnyObject! = NSJSONSerialization.JSONObjectWithData(data,
            options: NSJSONReadingOptions(0), error: &error)
        
        
        if let jsonObject = jsonObject as? [String: AnyObject] where error == nil,
            
            let jsonData = JSONValue.fromObject(jsonObject)?["data"]?.array {
                for placeJSON in jsonData {
                    if let placeJSON = placeJSON.array,
                        // 5
                        place = Place.fromJSON(placeJSON) {
                            places.append(place)
                    }
                }
        }
    }
    

    
}

