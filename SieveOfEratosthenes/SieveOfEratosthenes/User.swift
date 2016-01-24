//
//  User.swift
//  L6kalonso
//
//  Created by Kelly Alonso-Palt on 11/11/15.
//  Copyright © 2015 Kelly Alonso. All rights reserved.
//
import Foundation
import UIKit




class User: NSObject, NSCoding {
    
    //MARK: Properties
    
    struct PropertyKey {
        static let selfieKey = "selfie"
        static let nameKey = "name"
        static let highestPrimeKey = "highestPrime"
        // static let fewestErrorsKey = "fewestErrors"
        static let isGirlKey = "isGirl"
        static let sizeOfCollectionKey = "sizeOfCollection"
    }
    
    var defaultImage: UIImage = UIImage(named: "defaultPhoto")!
    var defaultPicBoy: UIImage = UIImage(named: "defaultImageBoy")!
    
    var selfie: UIImage?
    var name: String
    var highestPrime: Int?
    //var fewestErrors: String?
    var isGirl: Bool
    var sizeOfCollection: Int
    
    enum Gender: Int {
        case Boy = 0, Girl
        
        //        init() {
        //            self = .Boy
        //        }
    }
    
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("theUsers")
    
    
    
    //MARK: Initialization
    
    //    init(newPic: UIImage?, newName: String, Gender: Gender, highestPrime: String){
    //
    //        selfie = newPic
    //        name = newName
    //        self.Gender = Gender.rawValue
    //        self.
    //        level = highestPrime
    //        isGirl = false
    //
    //    }
    
    init(newPic: UIImage?, newName: String, girl: Bool, highPrime: Int?, sizeOfCollection: Int) {
        if let thisPic = newPic {
            self.selfie = thisPic
            
            if girl {
                self.isGirl = true
            } else {
                self.isGirl = false
            }
            
        }
        else if girl {
            self.selfie = defaultImage
            self.isGirl = true
        } else {
            self.selfie = defaultPicBoy
            self.isGirl = false
        }
        
        self.name = newName
        if let existingHighestPrime = highPrime {
            self.highestPrime = existingHighestPrime
        } else {
            self.highestPrime = nil
        }
        
        self.sizeOfCollection = sizeOfCollection
        //self.fewestErrors = ""
        
        super.init()
    }
    
    //MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(selfie, forKey: PropertyKey.selfieKey)
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(highestPrime, forKey: PropertyKey.highestPrimeKey)
        //aCoder.encodeObject(fewestErrors, forKey: PropertyKey.fewestErrorsKey)
        aCoder.encodeBool(isGirl, forKey: PropertyKey.isGirlKey)
        aCoder.encodeInteger(sizeOfCollection, forKey: PropertyKey.sizeOfCollectionKey)
    }
    
    convenience required init(coder aDecoder: NSCoder) {
        
        let selfie = aDecoder.decodeObjectForKey(PropertyKey.selfieKey) as? UIImage
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let highestPrime = aDecoder.decodeObjectForKey(PropertyKey.highestPrimeKey) as? Int
        //let fewestErrors = aDecoder.decodeObjectForKey(PropertyKey.fewestErrorsKey)
        let isGirl = aDecoder.decodeBoolForKey(PropertyKey.isGirlKey) as Bool
        let sizeOfCollection = aDecoder.decodeIntegerForKey(PropertyKey.sizeOfCollectionKey) as Int
        
        self.init(newPic: selfie, newName: name, girl: isGirl, highPrime: highestPrime, sizeOfCollection: sizeOfCollection)
        
    }
    
    
    
}