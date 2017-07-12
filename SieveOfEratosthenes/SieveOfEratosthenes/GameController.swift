//
//  GameController.swift
//  SieveOfEratosthenes
//
//  Created by Kelly Alonso-Palt on 11/18/15.
//  Copyright © 2015 Kelly Alonso. All rights reserved.
//

import Foundation

enum GameState {
    case findLowestPrime(lowestPrime: Int)
    case removeComposites(currentPrime: Int)
    case finish(lastPrime: Int?)
}

class GameController {
    
    //static let sharedInstance = GameController()

    //MARK: Properties
    var gameNumbers = [GameNumber]()
    var sizeOfCollection = 100
    var selectedIndices = [Int]()
    var state: GameState
    var ourVC: ViewController?
    var levelPassed = false
    
    

    //MARK: Initialization
    init(theVC: ViewController) {
      
        state = .findLowestPrime(lowestPrime: 2)
        ourVC = theVC
        if let size = ourVC!.sizeOfCollection {
            sizeOfCollection = size
            for index in 1...size {
                gameNumbers.append(GameNumber(number: index))
            }
        }

    }
    
    //MARK: GameSetUp
    func userSelectedNumber(_ gameNumber: GameNumber) {
        switch state {

        case .findLowestPrime(let lowestPrime):
            if gameNumber.value == lowestPrime {
                selectPrime(gameNumber)
                state = .removeComposites(currentPrime: lowestPrime)
                ourVC!.callAlertControllerForMultiples(lowestPrime)
            } else {
                ourVC!.vibrateThePhone()
            }
        case .removeComposites(let currentPrime):
            selectComposite(currentPrime, gameNumber: gameNumber)
            break
        
        case .finish:
            //segue to UserTableViewController
            break
        }
        print(gameNumber)

    }
    
    func userSelectedNextPrime(_ gameNumber: GameNumber) {
        
    }

    func skipToTheEnd() {

    }
    
    func userShookPhone() {
        //check for state
        print("checking state")
        switch state {
            
        case .findLowestPrime(let lowestPrime):
            print("FindlowestPrime")
            return
            
        case .removeComposites(let currentPrime):
            print("removeComposites")
            if userSelectedAllMultiples(currentPrime) {
                for index in selectedIndices {
                    print("hello")
                    //gameNumbers[index].state = .shaker
                    gameNumbers[index].state = .removed

                    print(index)
                }
                //ourVC?.shakeTheSieve()
//                for index in selectedIndices {
//                    print("hello")
//                    gameNumbers[index].state = .shaker
//                    //gameNumbers[index].state = .removed
//        
//                    print(index)
//                }
                //ourVC?.shakeTheSieve()
            if isLastPrime(currentPrime) {
                highlightThePrimes()
                state = .finish(lastPrime: theLastPrime())
                //sizeOfCollection += 100
                levelPassed = true
                endTheGame()
                return
            }
            selectedIndices.removeAll()
            state = .findLowestPrime(lowestPrime: findNextPrime(currentPrime))
            ourVC!.callAlertControllerForNextPrime()
            }

        case .finish:
            print("finish")
            return
        }
    }
    
    func findCorrespondingGameNumber(_ gameNumber: GameNumber) ->Int? {
        return gameNumbers.index(of: gameNumber)
    }
    
    func selectPrime(_ gameNumber: GameNumber) {
        if let currentIndex = findCorrespondingGameNumber(gameNumber) {
            gameNumbers[currentIndex].state = .selectedPrime
        }
    }
    
    func selectComposite(_ forPrime: Int, gameNumber: GameNumber) {
        switch state {
        case .findLowestPrime(let lowestPrime):
                return
        case .removeComposites(let currentPrime):
            switch gameNumber.state {
            case .removed:
                if gameNumber.value % currentPrime != 0 {
                    print("error")
                    ourVC!.vibrateThePhone()
                    print("\(gameNumber.value)  \(currentPrime)")
                    return
                }
                
                if let currentIndex = findCorrespondingGameNumber(gameNumber) {
                    gameNumbers[currentIndex].state = .selectedComposite
                    selectedIndices.append(currentIndex)
                    print("Current Index \(currentIndex)")
                    print(selectedIndices)
                }
            case .normal:
                
                if gameNumber.value % currentPrime != 0 {
                    print("error")
                    ourVC!.vibrateThePhone()
                    print("\(gameNumber.value)  \(currentPrime)")
                    return
                }
                
                if let currentIndex = findCorrespondingGameNumber(gameNumber) {
                    gameNumbers[currentIndex].state = .selectedComposite
                    selectedIndices.append(currentIndex)
                    print("Current Index \(currentIndex)")
                    print(selectedIndices)
                }
            case .selectedPrime:
                return
            case .selectedComposite:
                if let currentIndex = findCorrespondingGameNumber(gameNumber) {
                    gameNumbers[currentIndex].state = .normal
                    if let indexToBeDeleted = selectedIndices.index(of: currentIndex){
                        selectedIndices.remove(at: indexToBeDeleted)
                    }
                }
                return
            case .unit:
                return
            case .shaker:
                print("Not sure what to do here except return")
                return
                
        }

        case .finish:
            return
        }
    }
    
    func endTheGame() {
        switch state {
        case .finish(let lastPrime):
            ourVC?.sizeOfCollection = sizeOfCollection
            ourVC?.highestPrime = lastPrime
            ourVC?.callAlertControllerForFinish()
        case .findLowestPrime(let lowestPrime):
            ourVC?.sizeOfCollection = sizeOfCollection
            ourVC?.highestPrime = lowestPrime
            ourVC?.performSegueToUserTableViewController()
        case .removeComposites(let currentPrime):
            ourVC?.sizeOfCollection = sizeOfCollection
            ourVC?.highestPrime = currentPrime
            ourVC?.performSegueToUserTableViewController()
        }
    }
    
    //MARK: MathLogic
    func isPrime(_ currentNumber: Int) -> Bool {
        let possiblePrime = currentNumber
        let possiblePrimeFloat: Float = Float(possiblePrime)
        let endOfRange: Int = Int(sqrt(possiblePrimeFloat))
        
        if endOfRange <= 2 {
            if currentNumber == 3 {
                return true
            }
            if currentNumber == 4 {
                return false
            }
        }
    
        for i in 2...endOfRange {
            if possiblePrime % i == 0 {
                return false
            }
        }
        return true
    }
    
    func findNextPrime(_ forPrime: Int) ->Int {
        for i in (forPrime + 1)...sizeOfCollection {
            if isPrime(i) {
                return i
            }
         }
        return forPrime
    }
    
    func userSelectedAllMultiples(_ forPrime: Int) ->Bool {
        print("userSelectedAllMultiples")

        var numberOfErrors = 0
        for i in stride(from: (forPrime * 2), to: sizeOfCollection, by: forPrime) {
            if (numberIsNotSelected(gameNumbers[i - 1]) && !selectedIndices.contains(i - 1)) {
                numberOfErrors = numberOfErrors + 1
            }
        }
//        for i in (forPrime * 2)...sizeOfCollection {
//            if (numberIsNotSelected(gameNumbers[i - 1]) && !selectedIndices.contains(i - 1)) {
//                numberOfErrors = numberOfErrors + 1
//            }
//
//        }
//        for var i = (forPrime * 2); i <= sizeOfCollection; i += forPrime {
//            
//            if numberIsNotSelected(gameNumbers[i - 1]) && !selectedIndices.contains(i - 1) {
//                numberOfErrors += 1
//            }
//        }
        if numberOfErrors > 0 {
            ourVC!.callTheAlertControllerForMissedMultiple(numberOfErrors)
            return false
        } else {
            print("true")
            return true
        }
    }
    
    func isLastPrime(_ forPrime: Int) -> Bool {
        let sizeOfCollectionFloat: Float = Float(sizeOfCollection)
        let highestPossible: Int = Int(sqrt((sizeOfCollectionFloat)))
        let nextPrime = findNextPrime(forPrime)
        print("comparing \(nextPrime) and \(highestPossible)")
        return nextPrime > highestPossible
    }
    
    func numberIsNotSelected(_ gameNumber: GameNumber) -> Bool {

        return gameNumber.state == .normal
    }
    
    func highlightThePrimes() {
        for remainingNumber in gameNumbers {
            if numberIsNotSelected(remainingNumber) {
                if let index = findCorrespondingGameNumber(remainingNumber) {
                    gameNumbers[index].state = .selectedPrime
                    print("\(gameNumbers[index].state)")
                }

                print("\(remainingNumber.value)")
            }
        }
    }
    
    func theLastPrime() -> Int {
        
        for i in (1...sizeOfCollection).reversed() {
            if isPrime(i) {
                print("returning \(i)")
                return i
            }
        }
        return -1
    }
    

    
}
