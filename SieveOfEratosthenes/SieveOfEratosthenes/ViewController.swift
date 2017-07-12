//
//  ViewController.swift
//  SieveOfEratosthenes
//
//  Created by Kelly Alonso-Palt on 11/5/15.
//  Copyright © 2015 Kelly Alonso. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation
import SpriteKit


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AVAudioPlayerDelegate {

    //MARK: Properties
    
    var count = 1
    
    @IBOutlet var animationView: SKView!
    @IBOutlet var collectionView: UICollectionView!
    
    //static let sharedInstance: ViewController = ViewController()
  
    var sizeOfCollection: Int?
    var highestPrime: Int?
    var ourGC: GameController?
    var ourAnimationScene: AnimationScene?
    var midPoint: CGPoint?
    //let awesomeSound = SKAction.playSoundFileNamed("Awesome.m4a", waitForCompletion: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.becomeFirstResponder()
        ourGC = GameController(theVC: self)
//        midPoint = CGPoint(x: self.collectionView.frame.midX - 20, y: self.collectionView.frame.midY - 32)
//        print("View did load midpoint = \(midPoint)")


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
            //cell.shakeUpTheCells()
        }
//        cell.layer.borderColor = UIColor.gray.cgColor
//        cell.layer.borderWidth = 1

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
//        playTheSound()
//        play(for: "Awesome", type: "m4a")

        let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell
        if let gameNumber = cell?.gameNumber {
            ourGC?.userSelectedNumber(gameNumber)
        }
        collectionView.reloadData()
    }
    
    //MARK: GameSetUp
    
    func startTheGame(_ alert: UIAlertAction! = nil) {
        
    }

    func studyThePrimes(_ alert: UIAlertAction! = nil) {
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ViewController.performSegueToUserTableViewController))
        self.navigationItem.rightBarButtonItem = button
        self.navigationItem.setHidesBackButton(true, animated: true)
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
        ac.addAction(UIAlertAction(title: "Look at the numbers", style: .default, handler: studyThePrimes))
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

    func shakeTheSieve() {
        playTheSound()
        let shakingCells = getTheShakeableCells()
        //animateCellsWithMotionEffects(cells: shakingCells)
        animateCellsWithBlock(cells: shakingCells)
        //cellsToNodes()
        //littleSprite()
//        animationView = spriteMyGame()
//        self.view.addSubview(animationView)
        //self.view.superview?.bringSubview(toFront: view)
//        for cell in self.collectionView.visibleCells {
//            if let indexPath = self.collectionView.indexPath(for: cell) {
//                if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
//                    if cell.shouldShake {
//                        cell.superview?.bringSubview(toFront: cell)
//                        self.view.bringSubview(toFront: cell)
//                        cell.shakeUpTheCells()
//                        cell.shouldShake = false
//                        collectionView.reloadData()
//
//                    }
//                }
//            }
//        }
    }

    //MARK: - Sounds
    
    func vibrateThePhone() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }

    func playTheSound() {
        if #available(iOS 9.0, *) {
            if let asset = NSDataAsset(name:"Awesome"){
                
                do {
                    
                    // Use NSDataAsset's data property to access the audio file stored in Sound.
                    let player = try AVAudioPlayer(data: asset.data)
                    // Play the above sound file.
                    player.volume = 1
                    player.delegate = self
                    player.prepareToPlay()
                    player.play()
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }

    func play(for resource: String, type: String) {
        // Prevent a crash in the event that the resource or type is invalid
        //guard let path = Bundle.main.path(forResource: resource, ofType: type) else { return }
        if let resourcePath = Bundle.main.resourcePath {
            let audioName = "Awesome.m4a"
            let path = resourcePath + "/" + audioName
            let sound = URL(fileURLWithPath: path)
            do {
                let audioPlayer = try AVAudioPlayer(contentsOf: sound)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch {
                // Create an assertion crash in the event that the app fails to play the sound
                assert(false, error.localizedDescription)
            }
        }
        // Convert path to URL for audio player


    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("play finished")

        if !flag {
            //recordingEnded(success: false)
        } else {
            //recordingEnded(success: true)
        }
    }

    //MARK: - Sprite Kit
    func setTheScene() -> SKScene {
        print("I am not running")
        print("setting the scene")
       // let theNodes = cellsToNodes()
        let size = collectionView.frame.size
        let theScene = SKScene(size: size)
        theScene.physicsWorld.gravity = CGVector(dx: 0, dy: 1.8)
        let physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody.friction = 0.5

        theScene.physicsBody = physicsBody


    



        //theScene.anchorPoint = collectionView.frame.origin

        theScene.backgroundColor = UIColor.green
//        for node in theNodes {
//            theScene.addChild(node)
//            print("for node in nodes")
//        }
        return theScene
    }

    func cellsToNodes() -> [SKSpriteNode] {
        print("cells to nodes")
        var layout = TheLayout()

        var nodeArray = [SKSpriteNode]()
        for cell in self.collectionView.visibleCells {
            //print("for cell in visible cells")
            if let indexPath = self.collectionView.indexPath(for: cell) {
                self.collectionView.beginInteractiveMovementForItem(at: indexPath)
                self.collectionView.layoutAttributesForItem(at: indexPath)
                   layout.layoutAttributesForInteractivelyMovingItem(at: indexPath, withTargetPosition: CGPoint(x: 100, y: 300))
                    layout.finalizeAnimatedBoundsChange()

                if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
                    if cell.shouldShake {
                        cell.superview?.bringSubview(toFront: cell)
                        //cell.shakeUpTheCells()
                        let theEffects = getTheMotionEffects()
                        cell.addMotionEffect(theEffects)
                        UIView.animate(withDuration: 5, animations: {
                            cell.removeMotionEffect(theEffects)
                            //self.collectionView.reloadItems(at: [indexPath])
                        })

                        if let node = cell.spawnThyself() {
                            print("cell should shake")
                            nodeArray.append(node)
                            //spriteScene.addChild(node)
                            cell.shouldShake = false
                            cell.gameNumber?.state = .removed
                        }

                    }
                }
            }
        }
        collectionView.reloadData()
        return nodeArray
    }

    func getTheShakeableCells() -> [CollectionViewCell] {
        var cells = [CollectionViewCell]()
        for cell in self.collectionView.visibleCells {
            //print("for cell in visible cells")
            if let indexPath = self.collectionView.indexPath(for: cell) {
                if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
                    if cell.shouldShake {
                        
                        cells.append(cell)
                        print("The cells game number is \(cell.gameNumber)")
                    }
                }
            }
        }
        return cells
    }

    func animateCellsWithMotionEffects(cells: [CollectionViewCell]) {
        let motionEffects = getTheMotionEffects()
        for cell in cells {
            cell.superview?.bringSubview(toFront: cell)
            cell.addMotionEffect(motionEffects)

        }
    }

    func animateCellsWithBlock(cells: [CollectionViewCell]) {
        //self.collectionView.superview?.shake()
        let bigAnimation = shakeAnimation(frame: self.collectionView.frame)
        self.collectionView.layer.add(bigAnimation, forKey: "animation")
//        collectionView.superview?.transform = CGAffineTransform(translationX: 20, y: 0)
//        UIView.animate(withDuration: 5.0, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: .curveEaseInOut, animations:{
//            self.collectionView.superview?.transform = CGAffineTransform.identity
//        }, completion: nil)
        for cell in cells {
            let animation = shakeAnimation(frame: cell.frame)
            UIView.animate(withDuration: 6, animations: {
                cell.superview?.bringSubview(toFront: cell)
                cell.layer.add(animation, forKey: "animation")


            })
            cell.transform = CGAffineTransform(translationX: 20, y: 0)
            //cell.layer.affineTransform()

            UIView.animate(withDuration: 3.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                print("Hi kelly. Im in the completion block")
                cell.transform = CGAffineTransform.identity
                cell.gameNumber?.state = .removed
                self.collectionView.reloadData()
            }, completion: nil)

        }
    }


    func getTheMotionEffects() ->UIMotionEffectGroup {

        let horizontalEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontalEffect.maximumRelativeValue = 150
        horizontalEffect.minimumRelativeValue = -150
        let verticalEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        verticalEffect.maximumRelativeValue = 150
        verticalEffect.minimumRelativeValue = -150

        let shadowEffect = UIInterpolatingMotionEffect(keyPath: "layer.shadowOffset", type: .tiltAlongHorizontalAxis)
        shadowEffect.minimumRelativeValue = CGSize(width: -10, height: 10)
        shadowEffect.maximumRelativeValue = CGSize(width: 10, height: 10)
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontalEffect, verticalEffect, shadowEffect]
        return group
    }




    func shakeAnimation(frame: CGRect) ->CAKeyframeAnimation {
        //let frame = cell.frame
        let numberOfShakes = 10
        let vigorOfShakes = 2
        let durationOfShake = 10
        let shakeAnimation = CAKeyframeAnimation(keyPath: "animation")
        let shakePath = CGMutablePath()
        shakePath.move(to: CGPoint(x: frame.minX, y: frame.minY))
        let thisX = frame.minX - frame.size.width * CGFloat(vigorOfShakes)

        let thatX = frame.minX + frame.size.width * CGFloat(vigorOfShakes)
        var thisPoint = CGPoint(x: thisX, y: frame.minY)
        if itDoesNotFit(point: thisPoint) {
            thisPoint = makeItFit(point: thisPoint)
        }
        var thatPoint = CGPoint(x: thatX, y: frame.minY)
        if itDoesNotFit(point: thatPoint) {
            thatPoint = makeItFit(point: thatPoint)
        }


        for i in 1...numberOfShakes {
            print("Add line to \(thisPoint)")
            print("Add line to \(thatPoint)")
            print("Cell is at \(frame.origin)")
            shakePath.addLine(to: thisPoint)
            shakePath.addLine(to: thatPoint)
        }
        shakePath.closeSubpath()
        shakeAnimation.path = shakePath
        shakeAnimation.duration = CFTimeInterval(durationOfShake)
        return shakeAnimation

    }

    func itDoesNotFit(point: CGPoint) ->Bool {
        let x = point.x
        let min: CGFloat = 0
        let max = self.collectionView.frame.maxX + 50
        return x < min || x > max
    }

    func makeItFit(point: CGPoint)->CGPoint {
        let y = point.y
        if point.x < 0 {

            return CGPoint(x: 3, y: y)

        } else {
            return CGPoint(x: self.collectionView.frame.maxX - 70, y: y)
        }
    }

    func setTheBackground() ->SKSpriteNode? {
        print("I am not running")
        print("set the background")
        collectionView.reloadData()
        print("reloading the collection view")
        let size = CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
        UIGraphicsBeginImageContext(self.collectionView.bounds.size)
        self.collectionView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenShot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = screenShot {
            let texture = SKTexture(image: image)
            let node = SKSpriteNode(texture: texture)
            //node.color = CollectionViewCell.hexStringToUIColor(hex: "F5A8FF", alpha: 1)
            node.size = size
            //node.position = CGPoint(x: self.collectionView.frame.origin.x, y: self.collectionView.frame.origin.y)
            let midX = self.collectionView.frame.midX - 20
            let midY = self.collectionView.frame.midY - 32
            let midPoint = CGPoint(x: midX, y: midY)
            //node.position = CGPoint(self.collectionView.frame.midX)
            node.position = midPoint
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
    func spriteMyGame() -> SKView {
        print("I am not running")
        let nodes = cellsToNodes()


        let spriteScene = setTheScene()
        if let background = setTheBackground() {
            spriteScene.addChild(background)

        }
        for node in nodes {
            spriteScene.addChild(node)
        }
        let frame = CGRect(x: 30, y: 30, width: self.collectionView.frame.width - 20, height: self.collectionView.frame.height - 20)
        let theView = SKView(frame: self.collectionView.frame)

        //let theView = SKView(frame: frame)
        //theView.allowsTransparency = true
        //theView.backgroundColor = UIColor.orange
        theView.showsPhysics = true
        theView.presentScene(spriteScene)
//        for cell in self.collectionView.visibleCells {
//            if let indexPath = self.collectionView.indexPath(for: cell) {
//                if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
//                    if cell.shouldShake {
//                        if let node = cell.spawnThyself() {
//                            spriteScene.addChild(node)
//                            cell.shouldShake = false
//                        }
//
//                    }
//                }
//            }
//        }
        return theView
    }

    func littleSprite() {

        let midX = self.collectionView.frame.midX - 20


        let midY = self.collectionView.frame.midY - 32
        let theFrame = self.collectionView.frame
        let origin = self.collectionView.bounds.origin
        print("And the origin is \(origin)")
        print("the view controller says the frame is \(theFrame)")
//        let midPoint = CGPoint(x: midX, y: midY)
//        if self.midPoint == nil {
//            self.midPoint = midPoint
//        }

        print("The view controller says the midpoint is \(midPoint)")
        let animationScene = AnimationScene(size: self.collectionView.bounds.size)
        //let animationScene = AnimationScene(size: CGSize(width: 2048, height: 1536))
        if let scaleMode = SKSceneScaleMode(rawValue: 1) {
            animationScene.scaleMode = scaleMode
        }
        animationScene.ourVC = self
        animationScene.ourVCSize = self.collectionView.bounds.size
        animationScene.midPoint = self.midPoint
        //animationScene.ourVCFrame = self.collectionView.frame
        let theView = SKView(frame: self.collectionView.frame)

        //animationView.presentScene(animationScene)
        theView.presentScene(animationScene)
        self.view.addSubview(theView)
        //self.view.addSubview(animationView)
        //self.view.superview?.addSubview(animationView)
        print("The node count is \(animationScene.nodeCount)")

        if animationScene.nodeCount == 1 {
            //theView.removeFromSuperview()
            self.collectionView.reloadData()
        }
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
        if let success = ourGC?.levelPassed {
            if let size = sizeOfCollection {
                sizeOfCollection = size + 100
            } else {
                sizeOfCollection = 200
            }
        }
        
        performSegue(withIdentifier: "UnwindToFinish", sender: self)
        
    }
 

}

