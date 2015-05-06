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
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String {
        return locationName
    }
}