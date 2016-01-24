//
//  CollectionViewCell.swift
//  SieveOfEratosthenes
//
//  Created by Kelly Alonso-Palt on 11/5/15.
//  Copyright © 2015 Kelly Alonso. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var numberLabel: UILabel!
   
    private(set) var gameNumber: GameNumber?
    
//    enum NumberState {
//        case Prime;
//        case Composite;
//        case Unit;
//    }
    
//    func currentNumber() -> Int {
//        return Int(self.numberLabel.text!)!
//    }
//    
//    func isPrime() -> Bool {
//        let possiblePrime = currentNumber()
//        let possiblePrimeFloat: Float = Float(possiblePrime)
//        
//        for i in 2...Int(sqrt(possiblePrimeFloat)) {
//            if possiblePrime % i == 0 {
//                return false
//            }
//        }
//        return true
//    }
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        
        if ((cString.characters.count) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0))
    }
    
    func takeThisGameNumber(gameNumber: GameNumber) {
        numberLabel.text = "\(gameNumber.value)"
        
        switch gameNumber.state {
        
        case .SelectedPrime:
            backgroundColor = hexStringToUIColor("B2FFA8")
//        case .SelectedComposite:
//            backgroundColor = hexStringToUIColor("D4FFA8")
        case .SelectedComposite:
            backgroundColor = hexStringToUIColor("F5A8FF")
        case .Removed:
            //backgroundColor = hexStringToUIColor("E4EFF5")
            //numberLabel.textColor = UIColor.grayColor()
            backgroundColor = UIColor.whiteColor()
            layer.borderColor = UIColor.whiteColor().CGColor
            layer.borderWidth = 0
            
        case .Normal:
            backgroundColor = hexStringToUIColor("A8DDFF")
        case .Unit:
            backgroundColor = hexStringToUIColor("F7FCF2")
        }
        
        self.gameNumber = gameNumber
    }
}
