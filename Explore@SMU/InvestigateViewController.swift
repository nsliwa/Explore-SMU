//
//  ThirdViewController.swift
//  Explore@SMU
//
//  Created by ch484-mac5 on 4/28/15.
//  Copyright (c) 2015 Team B.E.N. All rights reserved.
//
// ImagePickerController code adapted from ObjC from here: https://developer.apple.com/library/ios/samplecode/PhotoPicker/Introduction/Intro.html#//apple_ref/doc/uid/DTS40010196

import UIKit

class InvestigateViewController: UIViewController, NSURLSessionTaskDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // UI elements
    @IBOutlet weak var image_target: UIImageView!
    @IBOutlet weak var image_predict: UIImageView!
    var landmarkName: String = ""
    var currentLocation: String = ""
    var capturedImage: UIImage! = nil
    var targetImage: UIImage! = nil
    var landmarkObject: NSMutableArray = []
    
    var imagePickerController: UIImagePickerController! = nil
    
    // Camera overview
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var takePictureButton: UIBarButtonItem!
    @IBOutlet weak var overlayView: UIView!
    
    var uploadImage = false
    
    @IBOutlet weak var button_upload: UIButton!
    
    @IBOutlet weak var text_progress: UITextField!
    @IBOutlet weak var text_location: UITextView!
    @IBOutlet weak var text_info: UITextView!
    
    // session config
    //    let SERVER_URL: NSString = "http://guests-mac-mini-2.local:8000"
//    var SERVER_URL: NSString = "http://nicoles-macbook-pro.local:8000"
    var SERVER_URL: NSString = "http://teamben.cloudapp.net:8000"
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
        
        sessionConfig.timeoutIntervalForRequest = 15.0;
        sessionConfig.timeoutIntervalForResource = 18.0;
        sessionConfig.HTTPMaximumConnectionsPerHost = 1;
        
        session = NSURLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        
        if (!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            button_upload.userInteractionEnabled = false
            text_progress.text = "Oh, no! No camera found!"
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let id = defaults.integerForKey("dsid") as Int? {
            dsid = id
        }
        
        if let serverURL = defaults.stringForKey("Server_URL") as String? {
            SERVER_URL = serverURL
            NSLog("Connecting to server:%@", SERVER_URL)
        }
        else {
            NSLog("error in predicting")
        }
        
        // initialize data
        var img: String = NSString(format: "%@-detail", landmarkName) as String
        targetImage = UIImage(named: img)
        if targetImage != nil {
            image_target.image = targetImage
        }
        else {
            image_target.image = UIImage(named: "placeholder_icon")
        }
        
        
        if let landmarks: NSDictionary = defaults.dictionaryForKey("Landmarks") {
            let landmarkDict = NSMutableDictionary(dictionary: landmarks)
            landmarkObject = landmarkDict.objectForKey(landmarkName) as! NSMutableArray
            text_location.text = landmarkObject[0] as! NSString as String
        }
        
        if capturedImage != nil {
            image_predict.image = capturedImage
        }
        else {
            image_predict.image = UIImage(named: "placeholder_icon")
        }
//        button_upload.backgroundColor = UIColor.clearColor()
        
    }
    
    
    
    
    
    
    func askWatson(question:NSString) {
        
        //TODO:
        // get question for watson based on location
        // API call
        // populate info
    }
    
    
    @IBAction func onClick_capture(sender: UIButton) {
        
        showImagePickerForCamera()
        
    }
    
    @IBAction func done(sender: UIButton) {
        
        uploadImage = false
        finishAndUpdate()
        
    }
    
    @IBAction func takePhoto(sender: UIButton) {
        
        imagePickerController.takePicture()
        
    }
    
    
    func showImagePickerForCamera() {
        
        if(image_predict.isAnimating()) {
            image_predict.stopAnimating()
        }
        
        imagePickerController = UIImagePickerController()
        imagePickerController.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        imagePickerController.delegate = self
        
        imagePickerController.showsCameraControls = false

        /*
        Load the overlay view from the OverlayView nib file. Self is the File's Owner for the nib file, so the overlayView outlet is set to the main view in the nib. Pass that view to the image picker controller to use as its overlay view, and set self's reference to the view to nil.
        */
        NSBundle.mainBundle().loadNibNamed("OverlayView", owner: self, options: nil)
        overlayView.frame = imagePickerController.cameraOverlayView!.frame
        imagePickerController.cameraOverlayView = overlayView
        overlayView = nil
        
        presentViewController(imagePickerController, animated: true, completion: nil)
        
    }
    
    func finishAndUpdate() {
        dismissViewControllerAnimated(true, completion: nil)
        
        if capturedImage != nil {
            image_predict.image = capturedImage
            
        }
        if(uploadImage) {
            NSLog("call func to upload image now")
            
            uploadPredictImage()
        }
        
        imagePickerController = nil
    }
    

//    #pragma mark - UIImagePickerControllerDelegate
    
    // This method is called when an image has been chosen from the library or taken from the camera.
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        var image:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        capturedImage = image
        
        uploadImage = true
        
        finishAndUpdate()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    func uploadPredictImage() {
        // convert UIImage to NSData
//        var downSampledImg = image_predict.image
        var downSampledImg = resizeImage(image_predict.image!, newSize: CGSize(width: 100, height: 100))

        var imageData = UIImagePNGRepresentation(downSampledImg)
        let base64ImageString = imageData.base64EncodedStringWithOptions(.allZeros)
        
        // build data dictionary
        var data: NSMutableDictionary = NSMutableDictionary()
        data["img"] = base64ImageString
        
        // update text label with progress
        // update button background color with progress
//        button_upload.backgroundColor = UIColor.blueColor()
        button_upload.imageView?.image = UIImage(named: "camera-blue")
        self.text_progress.text = "Checking Your Answer"
        
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
        NSLog("predicting to: %@", baseURL)
        let postURL: NSURL = NSURL(string: baseURL as String)!
        
        // data to send in body of post request (send arguments as json)
        var error: NSError?
//        var jsonUpload: NSDictionary = ["dsid":currentLocation]
        var jsonUpload: NSDictionary = ["feature":featureData, "dsid":currentLocation]
//        var jsonUpload: NSDictionary = ["feature":"feature", "dsid":currentLocation]
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
                        if(labelResponse == self.landmarkName) {
                            dispatch_async(dispatch_get_main_queue()) {
                                self.button_upload.imageView?.image = UIImage(named: "camera-green")
//                                self.button_upload.backgroundColor = UIColor.greenColor()
//                                self.text_location.text = labelResponse as String
                                self.text_progress.text = "You got it!"
                                
                                self.askWatson(self.landmarkObject[1] as! NSString)
                                
                                let defaults = NSUserDefaults.standardUserDefaults()
                                
                                if let discovered = defaults.arrayForKey("FoundLandmarks") {
                                    var allDiscovered = NSMutableSet(array: discovered)
                                    allDiscovered.addObject(self.landmarkName)
                                    
                                    for obj in allDiscovered {
                                        NSLog(obj as! String)
                                    }
                                    
                                    var discoveredArray = allDiscovered.allObjects as NSArray
                                    
                                    defaults.setObject(discoveredArray, forKey: "FoundLandmarks")
                                    
                                    defaults.synchronize()
                                }
                            }
                        }
                        else {
                            dispatch_async(dispatch_get_main_queue()) {
                                self.button_upload.imageView?.image = UIImage(named: "camera-red")
//                                self.button_upload.backgroundColor = UIColor.redColor()
//                                self.text_location.text = labelResponse as String
                                self.text_progress.text = "Sorry! Please try again."
                            }
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
                NSLog("error: \n\t%@\n\t%@\n\t%@\n\t%@", err.localizedDescription, err.localizedDescription, err.localizedDescription, err.description)
            }
            
            if(self.errorCount > 0) {
                dispatch_async(dispatch_get_main_queue()) {
                    self.text_progress.text = "Failed to connect to server."
//                    self.text_progress.text = NSString(format:"%d Errors Occured", self.errorCount) as String
//                    self.button_upload.backgroundColor = UIColor.redColor()
                    self.button_upload.imageView?.image = UIImage(named: "camera-red")
                    
                    NSLog(self.errorMsgs)
                }
            }
//            else {
//                dispatch_async(dispatch_get_main_queue()) {
//                    self.text_progress.text = "Prediction Upload Successful"
//                    self.button_upload.backgroundColor = UIColor.greenColor()
//                }
//            }
            
            dispatch_async(dispatch_get_main_queue()) {
                // enable buttons after processing
                self.button_upload.userInteractionEnabled = true
            }
            
        })
        
        postTrack.resume()
        
    }

    //http://stackoverflow.com/questions/6141298/how-to-scale-down-a-uiimage-and-make-it-crispy-sharp-at-the-same-time-instead
    func resizeImage(image: UIImage, newSize: CGSize)-> UIImage {
        let newRect: CGRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height))
        let imageRef: CGImageRef = image.CGImage
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        let context: CGContextRef = UIGraphicsGetCurrentContext()
        
        // Set the quality level to use when rescaling
        CGContextSetInterpolationQuality(context, kCGInterpolationHigh)
        let flipVertical: CGAffineTransform  = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height)
        
        CGContextConcatCTM(context, flipVertical)
        // Draw into the context; this scales the image
        CGContextDrawImage(context, newRect, imageRef)
        
        // Get the resized image from the context and a UIImage
        let newImageRef: CGImageRef = CGBitmapContextCreateImage(context);
        let newImage: UIImage = UIImage(CGImage: newImageRef)!
        
//        CGImageRelease(newImageRef)
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
}

