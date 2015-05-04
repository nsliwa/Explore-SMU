//
//  FirstViewController.swift
//  Explore@SMU
//
//  Created by ch484-mac5 on 4/28/15.
//  Copyright (c) 2015 Team B.E.N. All rights reserved.
//

import UIKit
import MapKit

class FirstViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem = UITabBarItem(title: "Explore!", image: nil, tag: 1)
        self.mapView.showsUserLocation = true
        
        // Do any additional setup after loading the view, typically from a nib.
    }


}

