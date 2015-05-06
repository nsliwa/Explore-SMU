//
//  ThirdViewController.swift
//  Explore@SMU
//
//  Created by ch484-mac5 on 4/28/15.
//  Copyright (c) 2015 Team B.E.N. All rights reserved.
//

import UIKit

class InvestigateViewController: UIViewController, NSURLSessionTaskDelegate {
    
    // UI elements
    @IBOutlet weak var image_target: UIImageView!
    @IBOutlet weak var image_predict: UIImageView!
    var landmarkName: String = ""
    var capturedImage: UIImage! = nil
    var targetImage: UIImage! = nil
    
    @IBOutlet weak var button_upload: UIButton!
    
    @IBOutlet weak var text_progress: UITextField!
    @IBOutlet weak var text_location: UITextView!
    @IBOutlet weak var text_info: UITextView!
    
    // session config
    //    let SERVER_URL: NSString = "http://guests-mac-mini-2.local:8000"
    var SERVER_URL: NSString = "http://nicoles-macbook-pro.local:8000"
    let UPDATE_INTERVAL = 1/10.0
    
    var session: NSURLSession! = nil
    var taskID = 0
    var dsid = 0
    
    // keeps track of errors
    var errorCount = 0
    var errorMsgs = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.tabBarItem = UITabBarItem(title: "Scavenger hunt", image: nil, tag: 3)
        // Do any additional setup after loading the view, typically from a nib.
        
        //setup NSURLSession (ephemeral)
        let sessionConfig: NSURLSessionConfiguration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        
        sessionConfig.timeoutIntervalForRequest = 5.0;
        sessionConfig.timeoutIntervalForResource = 8.0;
        sessionConfig.HTTPMaximumConnectionsPerHost = 1;
        
        session = NSURLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let id = defaults.integerForKey("dsid") as Int? {
            dsid = id
        }
        
        if let serverURL = defaults.stringForKey("Server_URL") as String? {
            SERVER_URL = serverURL
        }
        else {
            NSLog("error in predicting")
        }
        
        // initialize data
        var img: String = NSString(format: "%@", landmarkName) as String
        targetImage = UIImage(named: img)
        image_target.image = targetImage
        if capturedImage != nil {
            image_predict.image = capturedImage
        }
        else {
            image_predict.image = UIImage(named: "placeholder_icon")
        }
//        button_upload.backgroundColor = UIColor.clearColor()
        
    }
    
    
    
    
    
    
    func askWatson() {
        
        //TODO:
        // get question for watson based on location
        // API call
        // populate info
    }
    
    
    @IBAction func onClick_upload(sender: UIButton) {
        
        // convert UIImage to NSData
        var imageData = UIImagePNGRepresentation(image_predict.image)
        let base64ImageString = imageData.base64EncodedStringWithOptions(.allZeros)
        
        // build data dictionary
        var data: NSMutableDictionary = NSMutableDictionary()
        data["img"] = base64ImageString
        //        data["gps"] = NSDictionary(dictionary: ["lat": capturedLocation.latitude, "long": capturedLocation.longitude])
        //        data["compass"] = NSDictionary(dictionary: ["x": capturedMagneticField.field.x, "y": capturedMagneticField.field.y, "z": capturedMagneticField.field.z])
        //        data["time"] = capturedTime
        
        // update text label with progress
        // update button background color with progress
        button_upload.backgroundColor = UIColor.blueColor()
        self.text_progress.text = "Uploading"
        
        // API call
        predictFeature(data)
        
        // future dev:
        // askWatson()
    }
    
    func predictFeature(featureData: NSDictionary) {
        // Add a data point and a label to the database for the current dataset ID
        
        // TODO: get correct dsid
        
        errorCount = 0
        errorMsgs = ""
        
        self.button_upload.userInteractionEnabled = false
        
        // setup the url
        let baseURL: NSString = NSString(format: "%@/PredictLocation",SERVER_URL)
        let postURL: NSURL = NSURL(string: baseURL as String)!
        
        // data to send in body of post request (send arguments as json)
        var error: NSError?
        var jsonUpload: NSDictionary = ["feature":featureData, "dsid":dsid]
        //        var jsonUpload: NSDictionary = ["feature":"data", "dsid":0]
        
        let requestBody: NSData! = NSJSONSerialization.dataWithJSONObject(jsonUpload, options: NSJSONWritingOptions.PrettyPrinted, error: &error)
        
        //        NSLog("request: %@",  NSString(data: requestBody, encoding: NSUTF8StringEncoding)!)
        
        // create a custom HTTP POST request
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: postURL)
        
        request.HTTPMethod = "POST"
        request.HTTPBody = requestBody
        
        //        NSLog("requestBody: %@",  NSString(data: request.HTTPBody!, encoding: NSUTF8StringEncoding)!)
        
        // disable buttons while processing
        //        button_upload.enabled = false
        
        // start the request, print the responses etc.
        let postTrack: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { ( d:NSData!, response:NSURLResponse!, err:NSError! ) -> Void in
            if(err == nil) {
                NSLog("response: %@", response)
                NSLog("data: %@",  NSString(data: d, encoding: NSUTF8StringEncoding)!)
                
                //                let jsonResponse: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: 0, error: nil)
                //                let results: NSDictionary = jsonResponse.valueForKey("locations")
                
                if let responseData: NSDictionary = NSJSONSerialization.JSONObjectWithData(d, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
                    
                    if let labelResponse: NSString = responseData["label"] as? NSString {
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            self.button_upload.backgroundColor = UIColor.greenColor()
                            self.text_location.text = labelResponse as String
                            self.text_progress.text = "Successful Response"
                        }
                        
                    }
                    else {
                        self.errorCount++
                        self.errorMsgs = self.errorMsgs + (NSString(format:"Error %d: Failed to get location label returned\n", self.errorCount) as String)
                    }
                    
                    
                }
                else {
                    self.errorCount++
                    self.errorMsgs = self.errorMsgs + (NSString(format:"Error %d: Server returned bad data\n", self.errorCount) as String)
                }
            }
                
            else {
                self.errorCount++
                self.errorMsgs = self.errorMsgs + (NSString(format:"Error %d: Failed to connect to server\n", self.errorCount) as String)
            }
            
            if(self.errorCount > 0) {
                dispatch_async(dispatch_get_main_queue()) {
                    self.text_progress.text = NSString(format:"%d Errors Occured", self.errorCount) as String
                    self.button_upload.backgroundColor = UIColor.redColor()
                    
                    NSLog(self.errorMsgs)
                }
            }
            else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.text_progress.text = "Prediction Upload Successful"
                    self.button_upload.backgroundColor = UIColor.greenColor()
                }
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                // enable buttons after processing
                self.button_upload.userInteractionEnabled = true
            }
            
        })
        
        postTrack.resume()
        
    }

    
    
}

