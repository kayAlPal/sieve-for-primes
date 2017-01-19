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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override func viewDidAppear(_ animated: Bool) {
  
        callAlertControllerForNextPrime()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: UICollectionViewDataSource
    
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        if let size = sizeOfCollection {
            return size
        } else {
            return 100
        }
        
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
    
        if let gameNumber = ourGC?.gameNumbers[indexPath.row] {
            cell.takeThisGameNumber(gameNumber)
        }
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 1
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout : UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth: CGFloat = screenSize.width;
            let cellWidth = screenWidth / 12.0; //Replace the divisor with the column count requirement. Make sure to have it in float.
            let size: CGSize = CGSize(width: cellWidth, height: cellWidth);
            
            return size;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell
        if let gameNumber = cell?.gameNumber {
            ourGC?.userSelectedNumber(gameNumber)
        }
        collectionView.reloadData()
    }
    
    //MARK: GameSetUp
    
    func startTheGame(_ alert: UIAlertAction! = nil) {
        
    }
    
    func callTheAlertControllerForMissedMultiple(_ numberMissing: Int) {
        let ac = UIAlertController(title: title, message: "Oops. You need to find \(numberMissing) more.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: returnToTheGame))
        present(ac, animated: true, completion: nil)
        
    }
    
    func callAlertControllerForNextPrime() {
        
        let ac = UIAlertController(title: title, message: "Please select the lowest prime number. Remember 1 is neither prime nor composite. It is a special case", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: startTheGame))
        present(ac, animated: true, completion: nil)
    }
    
    func callAlertControllerForMultiples(_ thePrime: Int) {
        let ac = UIAlertController(title: title, message: "Awesome! You found the prime number. Now remove its multiples and shake the phone. They aren't prime because they can all be put into boxes with rows of \(thePrime). Keep adding \(thePrime) to itself until the end.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: startTheGame))
        present(ac, animated: true, completion: nil)
    }
    
    func callAlertControllerForFinish() {
        let ac = UIAlertController(title: title, message: "Amazing! You have found all the prime numbers.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Look at the numbers", style: .default, handler: startTheGame))
        ac.addAction(UIAlertAction(title: "Finish", style: .default, handler: performSegueToUserTableViewController))
        present(ac, animated: true, completion: nil)
    }
    
    func returnToTheGame(_ alert: UIAlertAction! = nil) {
        
    }
    
    //MARK: MotionDetection
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as? UserTableViewController
        if let prime = highestPrime {
            destVC?.currentUser?.highestPrime = prime
            print("PFS highestPrime \(prime)")
        }
        if let size = sizeOfCollection {
            destVC?.currentUser?.sizeOfCollection = size
        }
    }
    
    func performSegueToUserTableViewController(_ alert: UIAlertAction! = nil) {
        
        performSegue(withIdentifier: "UnwindToFinish", sender: self)
        
    }
 

}

