//
//  LocationsTableViewController.swift
//  Explore@SMU
//
//  Created by Nicole Sliwa on 5/5/15.
//  Copyright (c) 2015 Team B.E.N. All rights reserved.
//

import UIKit

class LocationsTableViewController: UITableViewController, NSURLSessionTaskDelegate {

    var locationDict = NSMutableDictionary()
    var locationKeysArray = NSMutableArray()
    
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

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
//        var defaultDict: NSDictionary?
//        if let path = NSBundle.mainBundle().pathForResource("ScavengerHunt", ofType: "plist") {
//            defaultDict = NSDictionary(contentsOfFile: path)
//        }
//        if let dict = defaultDict {
//            NSUserDefaults.standardUserDefaults().registerDefaults(dict as [NSObject : AnyObject])
//        }
        
//        let defaults = NSUserDefaults.standardUserDefaults()
//        if let locations :NSDictionary = defaults.dictionaryForKey("Locations") {
//            locationDict = NSMutableDictionary(dictionary: locations)
//            locationKeysArray = NSMutableArray(array: locationDict.allKeys)
//        }

        //setup NSURLSession delegation (ephemeral)
        let sessionConfig: NSURLSessionConfiguration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        
        sessionConfig.timeoutIntervalForRequest = 5.0;
        sessionConfig.timeoutIntervalForResource = 8.0;
        sessionConfig.HTTPMaximumConnectionsPerHost = 1;
        
        session = NSURLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        
        
//        getLocations()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        getLocations()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        NSLog("getting num rows")
        return locationKeysArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("locationCell", forIndexPath: indexPath) as! UITableViewCell
        
        NSLog("getting cells")
        
        cell.textLabel!.text = locationKeysArray[indexPath.row] as? String

//         Configure the cell...

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        let vc = segue.destinationViewController as! LandmarksCollectionViewController
        let cell = sender as! UITableViewCell
        vc.location = cell.textLabel?.text as String!
    }
    
    func getLocations() {
        // setup the url
        var baseURL: NSString = NSString(format: "%@/GetLocations",SERVER_URL)
        
        var postURL: NSURL = NSURL(string: baseURL as String)!
        
        // data to send in body of post request (send arguments as json)
        var error: NSError?
        
        // create a custom HTTP POST request
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: postURL)
        
        request.HTTPMethod = "GET"
        
        NSLog("about to get locations")
        
        // start the request, print the responses etc.
        let postTrack: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { ( data:NSData!, response:NSURLResponse!, err:NSError! ) -> Void in
            if(err == nil) {
                NSLog("response: %@", response)
                NSLog("data: %@",  NSString(data: data, encoding: NSUTF8StringEncoding)!)
                
                if let responseData: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
                    
                    if let results: NSArray = (responseData.valueForKey("locations") as? NSArray) {
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            self.locationKeysArray.removeAllObjects()
                            self.locationKeysArray.addObjectsFromArray(results as [AnyObject])
                            
                            NSLog("got locations!")
                            
                            self.tableView.reloadData()
                            
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
