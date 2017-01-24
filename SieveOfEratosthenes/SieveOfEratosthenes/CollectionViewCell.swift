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
    var shouldShake = false
   
    fileprivate(set) var gameNumber: GameNumber?
    
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
    func hexStringToUIColor(hex: String, alpha: Float) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if cString.characters.count != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha))
    }
    
    func takeThisGameNumber(_ gameNumber: GameNumber) {
        numberLabel.text = "\(gameNumber.value)"
        
        switch gameNumber.state {
        
        case .selectedPrime:
            backgroundColor = hexStringToUIColor(hex: "B2FFA8", alpha: 1)
            layer.borderColor = UIColor.gray.cgColor
            layer.borderWidth = 1
            numberLabel.textColor = UIColor.black
            shouldShake = false
//        case .SelectedComposite:
//            backgroundColor = hexStringToUIColor("D4FFA8")
        case .selectedComposite:
            backgroundColor = hexStringToUIColor(hex: "F5A8FF", alpha: 1)
            layer.borderColor = UIColor.gray.cgColor
            layer.borderWidth = 1
            shouldShake = true
            numberLabel.textColor = UIColor.black
        case .removed:
            //backgroundColor = hexStringToUIColor("E4EFF5")
            //numberLabel.textColor = UIColor.grayColor()
            shouldShake = false
            backgroundColor = UIColor.white
            layer.borderColor = UIColor.white.cgColor
            layer.borderWidth = 1
            numberLabel.textColor = UIColor.lightGray
            
        case .normal:
            backgroundColor = hexStringToUIColor(hex: "A8DDFF", alpha: 1)
            layer.borderColor = UIColor.gray.cgColor
            layer.borderWidth = 1
            numberLabel.textColor = UIColor.black
            shouldShake = false
        case .unit:
            backgroundColor = hexStringToUIColor(hex: "F7FCF2", alpha: 1)
            layer.borderColor = UIColor.gray.cgColor
            layer.borderWidth = 1
            numberLabel.textColor = UIColor.black
            shouldShake = false
        }
        
        self.gameNumber = gameNumber
    }

    func shakeUpTheCells() {
        if shouldShake {
            print("Shakeable: \(gameNumber?.value)")
            //self.contentView.didMoveToSuperview()
            self.contentView.shake()
            self.shouldShake = false
//            UIView.animate(withDuration: 5) {
////                self.bounds = CGRect(x: self.bounds.origin.x + 20, y: self.bounds.origin.y, width: self.bounds.width, height: self.bounds.height)
//                self.frame = CGRect(x: self.bounds.origin.x + 20, y: self.bounds.origin.y, width: self.bounds.width, height: self.bounds.height)
//            }
//            shouldShake = false
        }
    }
}

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
       
        animation.duration = 10.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
