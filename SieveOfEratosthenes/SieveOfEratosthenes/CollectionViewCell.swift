//
//  CollectionViewCell.swift
//  SieveOfEratosthenes
//
//  Created by Kelly Alonso-Palt on 11/5/15.
//  Copyright © 2015 Kelly Alonso. All rights reserved.
//

import UIKit
import SpriteKit
class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var numberLabel: UILabel!
    var shouldShake = false
   
    //fileprivate(set) var gameNumber: GameNumber?
    var gameNumber: GameNumber?
    
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
            self.layer.shadowColor = UIColor.gray.cgColor
            self.layer.shadowOffset = CGSize(width: -1, height: -1)
            self.layer.shadowOpacity = 1
            self.layer.shadowRadius = 2
            self.layer.masksToBounds = false

//        case .SelectedComposite:
//            backgroundColor = hexStringToUIColor("D4FFA8")
        case .selectedComposite:
            backgroundColor = hexStringToUIColor(hex: "F5A8FF", alpha: 1)
            layer.borderColor = UIColor.gray.cgColor
            layer.borderWidth = 1
            shouldShake = true
            numberLabel.textColor = UIColor.black
            self.layer.shadowColor = UIColor.gray.cgColor
            self.layer.shadowOffset = CGSize(width: -1, height: -1)
            self.layer.shadowOpacity = 1
            self.layer.shadowRadius = 2
            self.layer.masksToBounds = false
        case .removed:
            //backgroundColor = hexStringToUIColor("E4EFF5")
            //numberLabel.textColor = UIColor.grayColor()
            shouldShake = false
            backgroundColor = UIColor.white
            //backgroundColor = UIColor.magenta
            layer.borderColor = UIColor.white.cgColor
            layer.borderWidth = 1
            numberLabel.textColor = UIColor.lightGray
            self.layer.shadowColor = UIColor.white.cgColor
            self.layer.masksToBounds = true
        case .shaker:
            backgroundColor = hexStringToUIColor(hex: "F5A8FF", alpha: 1)
            layer.borderColor = UIColor.gray.cgColor
            layer.borderWidth = 1
            shouldShake = true
            numberLabel.textColor = UIColor.black
            self.layer.shadowColor = UIColor.gray.cgColor
            self.layer.shadowOffset = CGSize(width: -1, height: -1)
            self.layer.shadowOpacity = 1
            self.layer.shadowRadius = 2
            self.layer.masksToBounds = false
        case .normal:
            backgroundColor = hexStringToUIColor(hex: "A8DDFF", alpha: 1)
            layer.borderColor = UIColor.gray.cgColor
            layer.borderWidth = 1
            numberLabel.textColor = UIColor.black
            shouldShake = false
            self.layer.shadowColor = UIColor.gray.cgColor
            self.layer.shadowOffset = CGSize(width: -1, height: -1)
            self.layer.shadowOpacity = 1
            self.layer.shadowRadius = 2
            self.layer.masksToBounds = false
        case .unit:
            backgroundColor = hexStringToUIColor(hex: "F7FCF2", alpha: 1)
            layer.borderColor = UIColor.gray.cgColor
            layer.borderWidth = 1
            numberLabel.textColor = UIColor.black
            shouldShake = false
            self.layer.shadowColor = UIColor.gray.cgColor
            self.layer.shadowOffset = CGSize(width: -2, height: -2)
            self.layer.shadowOpacity = 1
            self.layer.shadowRadius = 2
            self.layer.masksToBounds = false
        }
        
        self.gameNumber = gameNumber
    }

    func cellToImage() ->UIImage? {
        let size = CGSize(width: self.frame.width, height: self.frame.height)

        let image = drawCustomImage(size: size)

        return image ?? nil
    }


    func drawCustomImage(size: CGSize) -> UIImage? {
        // Setup our context
        let fillColor = hexStringToUIColor(hex: "F5A8FF", alpha: 1).cgColor
        let bounds = CGRect(origin: CGPoint.zero, size: size)
        let opaque = false
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        if let context = UIGraphicsGetCurrentContext() {
            // Setup complete, do drawing here
            context.setStrokeColor(UIColor.gray.cgColor)
            context.setLineWidth(10.0)

            context.stroke(bounds)

            context.beginPath()
            context.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
            //CGContextMoveToPoint(context, bounds.minX, bounds.minY)
            let maxX = bounds.maxX
            let maxY = bounds.maxY
            let minX = bounds.minX
            let minY = bounds.minY
            context.addLine(to: CGPoint(x: maxX, y: minY))
            context.addLine(to: CGPoint(x: maxX, y: maxY))
            //CGContextAddLineToPoint(context, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds))
            //context.move(to: CGPoint(x: bounds.maxX, y: bounds.minY))
            //CGContextMoveToPoint(context, CGRectGetMaxX(bounds), CGRectGetMinY(bounds))
            //CGContextAddLineToPoint(context, CGRectGetMinX(bounds), CGRectGetMaxY(bounds))
            context.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))
            context.addLine(to: CGPoint(x: minX, y: minY))
            context.setFillColor(fillColor)
            context.setShadow(offset: size, blur: 1)
            let smallerSize = CGSize(width: size.width - 1, height: size.height - 1)
            context.fill(CGRect(origin: CGPoint.zero, size: smallerSize))
            context.strokePath()




            //CGContextStrokePath(context)

            // Drawing complete, retrieve the finished image and cleanup
            let image = UIGraphicsGetImageFromCurrentImageContext()

            UIGraphicsEndImageContext()
            return image ?? nil
        }

        return nil
    }

    func spawnThyself() ->SKSpriteNode? {
        if let image = cellToImage() {
            let texture = SKTexture(image: image)
            let node = SKSpriteNode(texture: texture)
            let size = self.bounds.size
            node.size = size
            node.anchorPoint = CGPoint(x: 0, y: 1)
            node.zPosition = 100
            node.name = "\(self.gameNumber?.value)"

            node.position = CGPoint(x: self.frame.origin.x, y: self.frame.origin.y * 2.75)
            node.physicsBody = SKPhysicsBody(rectangleOf: size)
            node.physicsBody?.restitution = 1

            //node.physicsBody?.friction = 1

            //node.physicsBody?.allowsRotation = true
            node.physicsBody?.affectedByGravity = true
            node.physicsBody?.isDynamic = true
            node.physicsBody?.linearDamping = 1
            return node

        }





        let size = CGSize(width: self.frame.width, height: self.frame.height)
        let node = SKSpriteNode(color: hexStringToUIColor(hex: "F5A8FF", alpha: 1), size: size)
        node.position = CGPoint(x: self.frame.origin.x, y: self.frame.origin.y)
        node.physicsBody = SKPhysicsBody(rectangleOf: size)
        node.physicsBody?.restitution = 1

        //node.physicsBody?.friction = 1

        //node.physicsBody?.allowsRotation = true
        node.physicsBody?.affectedByGravity = true
        node.physicsBody?.isDynamic = true
        node.physicsBody?.linearDamping = 1
        return node
        let xPosition = self.frame.origin.x
        let yPosition = self.frame.origin.y
        let position = CGPoint(x: xPosition, y: yPosition)
       // let size = CGSize(width: self.frame.width, height: self.frame.height)
        UIGraphicsBeginImageContext(self.contentView.bounds.size)
        self.contentView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenShot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = screenShot {
            let texture = SKTexture(image: image)
            let node = SKSpriteNode(texture: texture)
            //node.color = hexStringToUIColor(hex: "F5A8FF", alpha: 1)
            node.size = size
            node.position = position

            node.physicsBody = SKPhysicsBody(rectangleOf: size)
            node.physicsBody?.restitution = 1

            //node.physicsBody?.friction = 1

            //node.physicsBody?.allowsRotation = true
            node.physicsBody?.affectedByGravity = true
            node.physicsBody?.isDynamic = true
            node.physicsBody?.linearDamping = 1
            //node.physicsBody?.mass = 0.1
             return node

        }
        return nil
        //node.centerRect = CGRect(origin: self.bounds.origin, size: size)




    }
    func shakeUpTheCells() {
        if shouldShake {
            print("Shakeable: \(gameNumber?.value)")
            self.contentView.didMoveToSuperview()
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

//    func shake() {
//
//
//        //self.contentView.superview?.bringSubview(toFront: cell)
//        self.addMotionEffect(getTheMotionEffects())
//        UIView.animate(withDuration: 0.5, animations: {
//            self.removeMotionEffect(self.getTheMotionEffects())
//            //self.collectionView.reloadItems(at: [indexPath])
//        })
//
//
//    }

    func getTheMotionEffects() ->UIMotionEffectGroup {

        let horizontalEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontalEffect.maximumRelativeValue = 250
        horizontalEffect.minimumRelativeValue = -250
        let verticalEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        verticalEffect.maximumRelativeValue = 250
        verticalEffect.minimumRelativeValue = -250

        let shadowEffect = UIInterpolatingMotionEffect(keyPath: "layer.shadowOffset", type: .tiltAlongHorizontalAxis)
        shadowEffect.minimumRelativeValue = CGSize(width: -10, height: 10)
        shadowEffect.maximumRelativeValue = CGSize(width: 10, height: 10)
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontalEffect, verticalEffect, shadowEffect]
        return group
    }
}
