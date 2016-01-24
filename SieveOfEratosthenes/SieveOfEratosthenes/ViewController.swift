//
//  ViewController.swift
//  SieveOfEratosthenes
//
//  Created by Kelly Alonso-Palt on 11/5/15.
//  Copyright © 2015 Kelly Alonso. All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK: Properties
    
    var count = 1
    
    @IBOutlet var collectionView: UICollectionView!
    
    //static let sharedInstance: ViewController = ViewController()
  
    var sizeOfCollection: Int? 
    var highestPrime: Int?
    var ourGC: GameController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.becomeFirstResponder()
        ourGC = GameController(theVC: self)
        

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let value = UIInterfaceOrientation.LandscapeLeft.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
    }
    
    override func viewDidAppear(animated: Bool) {
  
        callAlertControllerForNextPrime()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: UICollectionViewDataSource
    
     func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        if let size = sizeOfCollection {
            return size
        } else {
            return 100
        }
        
    }
    
     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
    
        if let gameNumber = ourGC?.gameNumbers[indexPath.row] {
            cell.takeThisGameNumber(gameNumber)
        }
        cell.layer.borderColor = UIColor.grayColor().CGColor
        cell.layer.borderWidth = 1
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout : UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            let screenWidth: CGFloat = screenSize.width;
            let cellWidth = screenWidth / 12.0; //Replace the divisor with the column count requirement. Make sure to have it in float.
            let size: CGSize = CGSizeMake(cellWidth, cellWidth);
            
            return size;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as? CollectionViewCell
        if let gameNumber = cell?.gameNumber {
            ourGC?.userSelectedNumber(gameNumber)
        }
        collectionView.reloadData()
    }
    
    //MARK: GameSetUp
    
    func startTheGame(alert: UIAlertAction! = nil) {
        
    }
    
    func callTheAlertControllerForMissedMultiple(numberMissing: Int) {
        let ac = UIAlertController(title: title, message: "Oops. You need to find \(numberMissing) more.", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .Default, handler: returnToTheGame))
        presentViewController(ac, animated: true, completion: nil)
        
    }
    
    func callAlertControllerForNextPrime() {
        
        let ac = UIAlertController(title: title, message: "Please select the lowest prime number. Remember 1 is neither prime nor composite. It is a special case", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .Default, handler: startTheGame))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    func callAlertControllerForMultiples(thePrime: Int) {
        let ac = UIAlertController(title: title, message: "Awesome! You found the prime number. Now remove its multiples and shake the phone. They aren't prime because they can all be put into boxes with rows of \(thePrime). Keep adding \(thePrime) to itself until the end.", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .Default, handler: startTheGame))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    func callAlertControllerForFinish() {
        let ac = UIAlertController(title: title, message: "Amazing! You have found all the prime numbers.", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "Look at the numbers", style: .Default, handler: startTheGame))
        ac.addAction(UIAlertAction(title: "Finish", style: .Default, handler: performSegueToUserTableViewController))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    func returnToTheGame(alert: UIAlertAction! = nil) {
        
    }
    
    //MARK: MotionDetection
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            ourGC!.userShookPhone()
        }
        print("shaking")
        collectionView.reloadData()
        
//        if let prime = highestPrime {
//            performSegueToUserTableViewController()
//        }
    
    }
    
    func vibrateThePhone() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    //MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destVC = segue.destinationViewController as? UserTableViewController
        if let prime = highestPrime {
            destVC?.currentUser?.highestPrime = prime
            print("PFS highestPrime \(prime)")
        }
        if let size = sizeOfCollection {
            destVC?.currentUser?.sizeOfCollection = size
        }
    }
    
    func performSegueToUserTableViewController(alert: UIAlertAction! = nil) {
        
        performSegueWithIdentifier("UnwindToFinish", sender: self)
        
    }
 

}

