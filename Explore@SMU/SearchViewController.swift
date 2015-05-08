//
//  SecondViewController.swift
//  Explore@SMU
//
//  Created by ch484-mac5 on 4/28/15.
//  Copyright (c) 2015 Team B.E.N. All rights reserved.
//

import UIKit
import MapKit

class SearchViewController: UIViewController {

    let regionRadius: CLLocationDistance = 1000
    var places = [Place]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        self.tabBarItem = UITabBarItem(title: "Search", image: nil, tag: 2)
        //self.mapView.showsUserLocation = true
        
        let initialLocation = CLLocation(latitude: 32.8441, longitude: -96.7849)
        
        self.mapView.showsUserLocation = true
        self.mapView.setUserTrackingMode(MKUserTrackingMode.FollowWithHeading, animated: true)
        
        self.centerMapOnLocation(initialLocation)
        
        //let meadowsMuseum = Place(title: "Meadows Museum", area: "By the boulevard", coordinate: CLLocationCoordinate2D(latitude: 32.8384, longitude: -96.7843))
        
        //mapView.addAnnotation(meadowsMuseum)
        
        loadInitialData()
        mapView.addAnnotations(places)
        
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
                for artworkJSON in jsonData {
                    if let artworkJSON = artworkJSON.array,
                        // 5
                        artwork = Place.fromJSON(artworkJSON) {
                            places.append(artwork)
                    }
                }
        }
    }



}

