//
//  Place.swift
//  Explore@SMU
//
//  Created by Brandon Malak on 06/05/15.
//  Copyright (c) 2015 Team B.E.N. All rights reserved.
//  MapKit Tutorial from Ray Wenderlich used for reference

import Foundation
import MapKit

class Place: NSObject, MKAnnotation {
    let title: String
    let area: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, area: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.area = area
        self.coordinate = coordinate
        
        super.init()
    }
    
    class func fromJSON(json: [JSONValue]) -> Place? {
        
        var title: String
        if let titleOrNil = json[1].string {
            title = titleOrNil
        } else {
            title = ""
        }
        
        let area = json[2].string
        
        let latitude = (json[3].string! as NSString).doubleValue
        let longitude = (json[4].string! as NSString).doubleValue
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        return Place(title: title, area: area!, coordinate: coordinate)
    }
    
    var subtitle: String {
        return area
    }
}