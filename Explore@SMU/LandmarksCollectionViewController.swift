//
//  LandmarksCollectionViewController.swift
//  Explore@SMU
//
//  Created by Nicole Sliwa on 5/5/15.
//  Copyright (c) 2015 Team B.E.N. All rights reserved.
//

import UIKit

let reuseIdentifier = "landmarkCell"

class LandmarksCollectionViewController: UICollectionViewController {

    var location: String = ""
    var locationDict = NSMutableDictionary()
    var landmarksArray = NSMutableArray()
    
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
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let locations :NSDictionary = defaults.dictionaryForKey("Locations") {
            locationDict = NSMutableDictionary(dictionary: locations)
            landmarksArray = NSMutableArray(array: locationDict[location] as! NSArray)
        }
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

}
