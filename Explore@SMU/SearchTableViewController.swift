//
//  SearchTableViewController.swift
//  Explore@SMU
//
//  Created by Nicole Sliwa on 5/8/15.
//  Copyright (c) 2015 Team B.E.N. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    var locationDict = NSMutableDictionary()
    var locationKeysArray = NSMutableArray()
    var places = [Place]()
    var index : Int = 0
    
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
//        if let locations :NSArray = defaults.arrayForKey("Places") {
//            locationKeysArray = NSMutableArray(array: locatios)
//        }
        
        
        
        loadInitialData()
        
//        ENDER: set this array
//        locationsKeysArray = //set array to what you want to display in table
        //locationKeysArray = NSMutableArray(array: ["test", "data", "only"])
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
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
        return places.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("locationCell", forIndexPath: indexPath) as! UITableViewCell
        
        NSLog("getting cells")
        
        cell.textLabel!.text = places[indexPath.row].title as? String
            //locationKeysArray[indexPath.row] as? String
        
        //         Configure the cell...
        
        return cell
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
    
    
    // MARK: - Navigation
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        index = indexPath.row
        NSLog("got index")
        self.performSegueWithIdentifier("searchWithIndex", sender: self)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        
        NSLog("segueing")
        
//        ENDER: Do your own stuff here
//        // Pass the selected object to the new view controller.
        let vc = segue.destinationViewController as! SearchViewController
        //let cell = sender as! UITableViewCell
        vc.place = places[index]
            //cell.textLabel?.text as String!
    }
    
    
}

