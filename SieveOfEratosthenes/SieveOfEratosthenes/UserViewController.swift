//
//  UserViewController.swift
//  L6kalonso
//
//  Created by Kelly Alonso-Palt on 11/11/15.
//  Copyright © 2015 Kelly Alonso. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet var nameTextField: UITextField!
   
   
    @IBOutlet var genderSegmentedControl: UISegmentedControl!
    
    @IBOutlet var photoImageView: UIImageView!
    
    
    
    @IBOutlet var saveButton: UIBarButtonItem!
    
    @IBOutlet var levelLabel: UILabel!
    var incomingSizeOfCollection = 100
    var highestPrimeAsInt: Int?
   
    
    var detailItem: User? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let thisUser = self.detailItem {
            nameTextField?.text = thisUser.name
            if let level = thisUser.highestPrime {
                levelLabel?.text = "\(level)"
                highestPrimeAsInt = level
            } else {
                levelLabel?.text = ""
            }
            photoImageView?.image = thisUser.selfie
            genderSegmentedControl?.isHidden = true
            incomingSizeOfCollection = thisUser.sizeOfCollection
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        nameTextField.delegate = self
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    //MARK: UITextFIeldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        checkValidName()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func checkValidName() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: UIPickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func takePictureForCell(_ sender: UITapGestureRecognizer) {
        
        //Hide the keyboard
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be taken, not picked.
        imagePickerController.sourceType = .camera
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationButton = sender as? UIBarButtonItem {
            if navigationButton == saveButton {
                let theImage = photoImageView.image
                let name = nameTextField.text ?? ""
                if genderSegmentedControl.selectedSegmentIndex == 0 {
                    detailItem = User(newPic: theImage, newName: name, girl: false, highPrime: highestPrimeAsInt, sizeOfCollection: incomingSizeOfCollection)
                } else {
                    detailItem = User(newPic: theImage, newName: name, girl: true, highPrime: highestPrimeAsInt, sizeOfCollection: incomingSizeOfCollection)
                }
            }
        }

    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        //        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        //        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        //
        //        if isPresentingInAddMealMode {
        //
        //            dismissViewControllerAnimated(true, completion: nil)
        //        }
        //
        //        else {
        //
        //            navigationController!.popViewControllerAnimated(true)
        //        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Prime Number Text Field
    
    func isPrime(_ possiblePrime: Int) -> Bool {
        
        let possiblePrimeFloat: Float = Float(possiblePrime)
        
        for i in 2...Int(sqrt(possiblePrimeFloat)) {
            if possiblePrime % i == 0 {
                return false
            }
        }
        return true
    }
    
    func textFieldDoesHavePrimeInt(_ textField: UITextField) -> Bool {
        if let possibleInt = Int(textField.text!) {
            if isPrime(possibleInt) {
                return true
            }
        }
        return false
    }
}

