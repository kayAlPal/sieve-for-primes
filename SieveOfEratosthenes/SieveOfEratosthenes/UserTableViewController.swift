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
    var ourDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(UserTableViewController.insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.userViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? UserViewController
            
        }
        
        if let lastUpdate = ourDefaults.object(forKey: "lastUpdate") as? Date {
            print("last update: \(lastUpdate)")
        }
        if let savedUsers = loadTheUsers() {
            theUsers += savedUsers
        }
        theUsers.append(practiceUser)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

    func insertNewObject(_ sender: AnyObject) {
        performSegue(withIdentifier: "newUser", sender: self)
//        players.insert(NSDate(), atIndex: 0)
//        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
//        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditUser" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = theUsers[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! UserViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
        if segue.identifier == "ToTheGame" {
            print("starting to the game")
            if let indexPath = self.tableView.indexPathForSelectedRow {
                currentUser = theUsers[indexPath.row]
                print(currentUser?.name)
                let destVC = segue.destination as? ViewController
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
    
    @IBAction func unwindToUserList(_ sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? UserViewController, let thisUser = sourceViewController.detailItem {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing user.
                theUsers[selectedIndexPath.row] = thisUser
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new user.
                let newIndexPath = IndexPath(row: 0, section: 0)
                theUsers.insert(thisUser, at: 0)
                tableView.insertRows(at: [newIndexPath], with: .bottom)
            }
            saveUsers()
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindToFinish(_ sender: UIStoryboardSegue) {
        print("UTF starting")
        if let sourceViewController = sender.source as? ViewController {
            print("inside first")
            if let thisUser = currentUser {
                print("inside second")
                thisUser.highestPrime = sourceViewController.highestPrime!
                print("UTF thisUser.highestPrime \(thisUser.highestPrime)")
                thisUser.sizeOfCollection = sourceViewController.sizeOfCollection!
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    // Update an existing user.
                    theUsers[selectedIndexPath.row] = thisUser
                    tableView.reloadRows(at: [selectedIndexPath], with: .none)
                }
            }
        }
        tableView.reloadData()
        saveUsers()
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        
        let thisUser = theUsers[indexPath.row]
        cell.nameLabel.text = thisUser.name
        cell.selfieSpot.image = thisUser.selfie
        if let level = thisUser.highestPrime {
            cell.levelLabel.text = "\(level)"
        } else {
            cell.levelLabel.text = ""
        }
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
//    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
//        performSegueWithIdentifier("EditUser", sender: self)
//    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            theUsers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveUsers()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    //MARK: NSCoding
    func saveUsers() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(theUsers, toFile: User.ArchiveURL.path)
        if !isSuccessfulSave {
            print("Failed to save users...")
        }
        
        // timestamp last update
        ourDefaults.set(Date(), forKey: "lastUpdate")
    }
    
    func loadTheUsers() -> [User]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: User.ArchiveURL.path) as? [User]
    }
}

