//
//  AnimationScene.swift
//  SieveOfEratosthenes
//
//  Created by Kelly Alonso-Palt on 1/26/17.
//  Copyright © 2017 Kelly Alonso. All rights reserved.
//

import Foundation
import SpriteKit

class AnimationScene: SKScene, SKPhysicsContactDelegate {

    struct PhysicsCategory {
        static let none: UInt32 = 0
        static let square: UInt32 = 0b1
        static let ball: UInt32 = 0b10
        static let border: UInt32 = 0b100
        static let all: UInt32 = UInt32.max

    }

    var ourVC: ViewController?
    var ourVCSize: CGSize?
    var ourVCFrame: CGRect? {
        if let width = ourVCSize?.width, let height = ourVCSize?.height {
            return CGRect(x: 20, y: 32, width: width, height: height)
        }
        return nil
    }
    var ourVCMidPoint: CGPoint? {
        if let midX = ourVCFrame?.midX, let midY = ourVCFrame?.midY{
            let shiftedX = midX - 20
            let shiftedY = midY - 32
            return CGPoint(x: shiftedX, y: shiftedY)
        }
        return nil

    }
    var nodeCount: Int {
        return self.children.count
    }
    var midPoint: CGPoint?
    var gameArea: CGRect
    var background: SKSpriteNode?
    override init(size: CGSize) {

       let maxAspectRatio: CGFloat = 16.0/9.0
 //       let maxAspectRatio: CGFloat = 9.0/16.0
        let playableWidth = size.height / maxAspectRatio
        let playableHeight = size.width / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        //let margin = (size.height - playableHeight) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        let totalArea = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        //gameArea = CGRect(x: 0, y: margin, width: size.width, height: playableHeight)
        print("The game area is \(gameArea)")
        print("The total area is \(totalArea)")
        print("The size is \(size)")
        super.init(size: size)

    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {

        print("Did move to view ourVCFrame is \(String(describing: ourVCFrame))")
        guard let theSize = ourVCSize else {
            return
        }
        self.physicsWorld.contactDelegate = self
        print("the size is \(theSize)")
        //let size = theSize

        //let theScene = SKScene(size: size)
        //self.size = theSize

        self.physicsWorld.gravity = CGVector(dx: 0, dy: 1.8)
        let physicsBody = SKPhysicsBody(rectangleOf: self.size)
        //let physicsBody = SKPhysicsBody(rectangleOf: gameArea.size)
        physicsBody.friction = 0.5
        physicsBody.categoryBitMask = PhysicsCategory.border
        physicsBody.collisionBitMask = PhysicsCategory.ball
        

        self.physicsBody = physicsBody









        self.backgroundColor = UIColor.green
        guard let backgroundImage = setTheBackground() else {
            return

        }
        background = backgroundImage
        if let theBackground = background {
            theBackground.size = self.size
            if let deadCenter = ourVCMidPoint {
                background?.position = deadCenter
                print("The background is positioned at \(deadCenter)")
                self.addChild(theBackground)

            }
        }

        //background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
//        if let midX = ourVCFrame?.midX, let midY = ourVCFrame?.midY{
//            let shiftedX = midX - 20
//            let shiftedY = midY - 32
//            background.position = CGPoint(x: shiftedX, y: shiftedY)
//            print("Our vc frame is \(ourVCFrame)")
//            print("Mid x and y are \(midX) \(midY)")
//            print("The background position is \(shiftedX) and \(shiftedY)")
//        }




//        if let point = midPoint {
//            self.anchorPoint = point
//        }
        if let theNodes = ourVC?.cellsToNodes() {
            print("We have the nodes")
            for node in theNodes {
                node.physicsBody?.categoryBitMask = PhysicsCategory.ball
                node.physicsBody?.collisionBitMask = PhysicsCategory.border | PhysicsCategory.ball
                print("adding the node")
                self.addChild(node)
            }
        }


    }



    func setTheBackground() ->SKSpriteNode? {


        if let frameSize = ourVCFrame?.size {
            print("The size for the background is \(frameSize)")
            if let screenshot = getTheScreenshotOfSize(size: frameSize) {
                let texture = SKTexture(image: screenshot)
                let node = SKSpriteNode(texture: texture, size: frameSize)
                return node
            }
        }
        if let vcSize = ourVCSize {
            if let screenshot = getTheScreenshotOfSize(size: vcSize) {
                let texture = SKTexture(image: screenshot)
                let node = SKSpriteNode(texture: texture, size: vcSize)
//                if let center = midPoint {
//                    node.position = center
//                }
                return node
            }
        }

        if let screenshot = getTheScreenshotOfSize(size: self.size) {
            let texture = SKTexture(image: screenshot)
            let node = SKSpriteNode(texture: texture, size: self.size)
            return node

        }

        return nil
        //let screenSize = gameArea.size
        let screenSize = CGSize(width: gameArea.width, height: gameArea.height)
        let gameRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        print("set the background")
        ourVC?.collectionView.reloadData()
        print("reloading the collection view")
        guard let theSize = ourVCSize else {
            return nil
        }
        print("the size is \(theSize)")

        guard let vc = ourVC else {
            return nil
        }
//        let size = CGSize(width: ourVC?.collectionView.frame.width, height: ourVC?.collectionView.frame.height)
        //UIGraphicsBeginImageContext(theSize)
        UIGraphicsBeginImageContext(self.size)
        //UIGraphicsBeginImageContext(screenSize)
        ourVC?.collectionView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenShot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = screenShot {
            let texture = SKTexture(image: image)
            //let texture = SKTexture(rect: gameRect, in: SKTexture(image: image))
            //let node = SKSpriteNode(texture: texture)
            let node = SKSpriteNode(texture: texture, size: self.size)
            //node.color = CollectionViewCell.hexStringToUIColor(hex: "F5A8FF", alpha: 1)
            //node.size = screenSize
            //node.size = self.size
            //node.position = CGPoint(x: self.collectionView.frame.origin.x, y: self.collectionView.frame.origin.y)
            //let midX = vc.collectionView.frame.midX - 20
            let middleX = self.size.width / 2
            let middleY = self.size.height / 2
            let officialSizeMidPoint = CGPoint(x: middleX, y: middleY)
            let middleScreenSizeX = screenSize.width / 2
            let middleScreenSizeY = screenSize.height / 2
            let centerScreenSize = CGPoint(x: middleScreenSizeX, y: middleScreenSizeY)
            //node.position = centerScreenSize
            node.position = officialSizeMidPoint
            node.zPosition = 0
            print("the screensize is \(screenSize)")
            print("The position of centerScreenSize midpoint is \(centerScreenSize)")
            print("The position of officialSizeMidPoint is \(officialSizeMidPoint)")

            //let midY = vc.collectionView.frame.midY - 32
            //let midPoint = CGPoint(x: midX, y: midY)
            print("The midpoint is \(String(describing: midPoint))")

//            if let theMidPoint = midPoint {
//                node.position = theMidPoint
//                //node.anchorPoint = theMidPoint
//
//            }




            //node.position = CGPoint(self.collectionView.frame.midX)

            //            node.physicsBody = SKPhysicsBody(rectangleOf: size)
            //            node.physicsBody?.affectedByGravity = false
            //            node.physicsBody?.isDynamic = false
            //node.physicsBody?.allowsRotation = true
            //node.physicsBody?.affectedByGravity = true
            //node.physicsBody?.isDynamic = true
            //node.physicsBody?.mass = 1
            return node

        }
        return nil
        
    }

    func getTheScreenshotOfSize(size: CGSize) ->UIImage? {
        UIGraphicsBeginImageContext(size)
        ourVC?.collectionView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenShot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return screenShot

    }

    func createPdfFromView(aView: UIView) ->CGContext? {
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil)
        UIGraphicsBeginPDFPage()

        guard let pdfContext = UIGraphicsGetCurrentContext() else { return nil}

        aView.layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()

        return pdfContext


    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let theFrame = ourVCFrame {
//            ourVC?.collectionView.frame = theFrame
//
//        }
        //self.removeAllChildren()

        self.view?.addSubview((ourVC?.collectionView)!)
    }

}
