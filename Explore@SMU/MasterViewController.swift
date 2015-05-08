//
//  MasterViewController.swift
//  Explore@SMU
//
//  Created by Nicole Sliwa on 5/4/15.
//  Copyright (c) 2015 Team B.E.N. All rights reserved.
//

import UIKit

class MasterViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        var defaultDict: NSDictionary?
        if let path = NSBundle.mainBundle().pathForResource("ScavengerHunt", ofType: "plist") {
            defaultDict = NSDictionary(contentsOfFile: path)
        }
        if let dict = defaultDict {
            NSUserDefaults.standardUserDefaults().registerDefaults(dict as [NSObject : AnyObject])
            NSLog("registering defaults")
        }
        else {
            NSLog("can't register defaults")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
