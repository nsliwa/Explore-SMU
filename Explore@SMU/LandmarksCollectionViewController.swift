//
//  LandmarksCollectionViewController.swift
//  Explore@SMU
//
//  Created by Nicole Sliwa on 5/5/15.
//  Copyright (c) 2015 Team B.E.N. All rights reserved.
//

import UIKit

let reuseIdentifier = "landmarkCell"



class LandmarksCollectionViewController: UICollectionViewController, NSURLSessionTaskDelegate {

    var location: String = ""
    var locationDict = NSMutableDictionary()
    var landmarksArray = NSMutableArray()
    var foundLandmarks = Array(["" as String])
    
    // session config
    //    let SERVER_URL: NSString = "http://guests-mac-mini-2.local:8000"
    //    var SERVER_URL: NSString = "http://nicoles-macbook-pro.local:8000"
    var SERVER_URL: NSString = "http://teamben.cloudapp.net:8000"
    let UPDATE_INTERVAL = 1/10.0
    
    var session: NSURLSession! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.registerClass(LandmarkCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        
//        self.collectionView.registerClass(CSSectionHeader.self,
//            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
//            withReuseIdentifier: "sectionHeader")

        // Do any additional setup after loading the view.
        
//        let defaults = NSUserDefaults.standardUserDefaults()
//        if let locations :NSDictionary = defaults.dictionaryForKey("Locations") {
//            locationDict = NSMutableDictionary(dictionary: locations)
//            landmarksArray = NSMutableArray(array: locationDict[location] as! NSArray)
//        }
        
        //setup NSURLSession delegation (ephemeral)
        let sessionConfig: NSURLSessionConfiguration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        
        sessionConfig.timeoutIntervalForRequest = 5.0;
        sessionConfig.timeoutIntervalForResource = 8.0;
        sessionConfig.HTTPMaximumConnectionsPerHost = 1;
        
        session = NSURLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let found: Array = defaults.arrayForKey("FoundLandmarks") {
            for obj in found {
                foundLandmarks.append(obj as! String)
            }
        }
        
        getLandmarks()
        
        NSLog("View appeared!")
//        collectionView?.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return landmarksArray.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! LandmarkCollectionViewCell
    
//        let landmarkCell = cell as! LandmarkCollectionViewCell
        var str: String = landmarksArray[indexPath.row] as! String
        NSLog(str)
        
        var bob = Array(["bob"])
        if( contains(bob, "bob") ) {
            
        }
        if( contains(foundLandmarks, str)) {
            cell.landmarkImage.layer.borderColor = UIColor.greenColor().CGColor
            cell.landmarkImage.layer.borderWidth = 5
        }
        
        if let img: UIImage = UIImage(named: str) {
            cell.landmarkImage?.image = img
        }
        else {
            NSLog("nil image")
        }
        // Configure the cell
        
        cell.landmarkLabel?.text = landmarksArray[indexPath.row] as? String
    
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! LandmarkCollectionViewCell
        
        let vc = segue.destinationViewController as! InvestigateViewController
        vc.landmarkName = cell.landmarkLabel.text! as String
        vc.currentLocation = location
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    
    func getLandmarks() {
        // setup the url
        var rawbaseURL: NSString = NSString(format: "%@/GetLandmarks?dsid=%@",SERVER_URL, location)
        let baseURL = rawbaseURL.stringByReplacingOccurrencesOfString(" ", withString: "%20")
//        let baseURL = rawbaseURL.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        NSLog("base url:%@ ", baseURL)
        
        var postURL: NSURL = NSURL(string: baseURL as String)!
        
        // data to send in body of post request (send arguments as json)
        var error: NSError?
        
        // create a custom HTTP POST request
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: postURL)
        
        request.HTTPMethod = "GET"
        
        NSLog("about to get landmarks")
        
        // start the request, print the responses etc.
        let postTrack: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { ( data:NSData!, response:NSURLResponse!, err:NSError! ) -> Void in
            if(err == nil) {
                NSLog("response: %@", response)
                NSLog("data: %@",  NSString(data: data, encoding: NSUTF8StringEncoding)!)
                
                if let responseData: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
                    
                    if let results: NSArray = (responseData.valueForKey("landmarks") as? NSArray) {
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            self.landmarksArray.removeAllObjects()
                            self.landmarksArray.addObjectsFromArray(results as [AnyObject])
                            
                            NSLog("got locations!")
                            
                            self.collectionView?.reloadData()
                            
                        }
                        
                    }
                    else {
                        
                    }
                }
                    
                    
                else {
                    
                }
                
            }
                
            else {
            }
            
        })
        
        postTrack.resume()
        
    }


}
