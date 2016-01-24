//
//  UserTableViewController.swift
//  L6kalonso
//
//  Created by Kelly Alonso-Palt on 11/11/15.
//  Copyright © 2015 Kelly Alonso. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var userViewController: UserViewController? = nil
    var theUsers = [User]()
    let practiceUser = User(newPic: nil, newName: "Newbie", girl: true, highPrime: nil, sizeOfCollection: 100)
    
    var currentUser: User?
    var ourDefaults = NSUserDefaults.standardUserDefaults()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.userViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? UserViewController
            
        }
        
        if let lastUpdate = ourDefaults.objectForKey("lastUpdate") as? NSDate {
            print("last update: \(lastUpdate)")
        }
        if let savedUsers = loadTheUsers() {
            theUsers += savedUsers
        }
        theUsers.append(practiceUser)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    func insertNewObject(sender: AnyObject) {
        performSegueWithIdentifier("newUser", sender: self)
//        players.insert(NSDate(), atIndex: 0)
//        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
//        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditUser" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = theUsers[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! UserViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
        if segue.identifier == "ToTheGame" {
            print("starting to the game")
            if let indexPath = self.tableView.indexPathForSelectedRow {
                currentUser = theUsers[indexPath.row]
                print(currentUser?.name)
                let destVC = segue.destinationViewController as? ViewController
                destVC?.sizeOfCollection = currentUser?.sizeOfCollection
            }
        }
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        if segue.identifier == "ToTheGame" {
//            if let indexPath = self.tableView.indexPathForSelectedRow {
//                currentUser = theUsers[indexPath.row]
//                let destVC = segue.destinationViewController as? ViewController
//                destVC?.sizeOfCollection = currentUser?.sizeOfCollection
//            }
//        }
//    }
    
    @IBAction func unwindToUserList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.sourceViewController as? UserViewController, thisUser = sourceViewController.detailItem {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing user.
                theUsers[selectedIndexPath.row] = thisUser
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }
            else {
                // Add a new user.
                let newIndexPath = NSIndexPath(forRow: 0, inSection: 0)
                theUsers.insert(thisUser, atIndex: 0)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            saveUsers()
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindToFinish(sender: UIStoryboardSegue) {
        print("UTF starting")
        if let sourceViewController = sender.sourceViewController as? ViewController {
            print("inside first")
            if let thisUser = currentUser {
                print("inside second")
                thisUser.highestPrime = sourceViewController.highestPrime!
                print("UTF thisUser.highestPrime \(thisUser.highestPrime)")
                thisUser.sizeOfCollection = sourceViewController.sizeOfCollection!
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    // Update an existing user.
                    theUsers[selectedIndexPath.row] = thisUser
                    tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
                }
            }
        }
        tableView.reloadData()
        saveUsers()
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theUsers.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomTableViewCell", forIndexPath: indexPath) as! CustomTableViewCell
        
        let thisUser = theUsers[indexPath.row]
        cell.nameLabel.text = thisUser.name
        cell.selfieSpot.image = thisUser.selfie
        if let level = thisUser.highestPrime {
            cell.levelLabel.text = "\(level)"
        } else {
            cell.levelLabel.text = ""
        }
        cell.layer.borderColor = UIColor.lightGrayColor().CGColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
//    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
//        performSegueWithIdentifier("EditUser", sender: self)
//    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            theUsers.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            saveUsers()
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    //MARK: NSCoding
    func saveUsers() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(theUsers, toFile: User.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save users...")
        }
        
        // timestamp last update
        ourDefaults.setObject(NSDate(), forKey: "lastUpdate")
    }
    
    func loadTheUsers() -> [User]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(User.ArchiveURL.path!) as? [User]
    }
}

