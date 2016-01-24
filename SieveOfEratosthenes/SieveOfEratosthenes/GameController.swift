//
//  GameController.swift
//  SieveOfEratosthenes
//
//  Created by Kelly Alonso-Palt on 11/18/15.
//  Copyright © 2015 Kelly Alonso. All rights reserved.
//

import Foundation

enum GameState {
    case FindLowestPrime(lowestPrime: Int)
    case RemoveComposites(currentPrime: Int)
    case Finish(lastPrime: Int?)
}

class GameController {
    
    //static let sharedInstance = GameController()

    //MARK: Properties
    var gameNumbers = [GameNumber]()
    var sizeOfCollection = 100
    var selectedIndices = [Int]()
    var state: GameState
    var ourVC: ViewController?
    
    

    //MARK: Initialization
    init(theVC: ViewController) {
      
        state = .FindLowestPrime(lowestPrime: 2)
        ourVC = theVC
        if let size = ourVC!.sizeOfCollection {
            sizeOfCollection = size
            for index in 1...size {
                gameNumbers.append(GameNumber(number: index))
            }
        }

    }
    
    //MARK: GameSetUp
    func userSelectedNumber(gameNumber: GameNumber) {
        switch state {

        case .FindLowestPrime(let lowestPrime):
            if gameNumber.value == lowestPrime {
                selectPrime(gameNumber)
                state = .RemoveComposites(currentPrime: lowestPrime)
                ourVC!.callAlertControllerForMultiples(lowestPrime)
            } else {
                ourVC!.vibrateThePhone()
            }
        case .RemoveComposites(let currentPrime):
            selectComposite(currentPrime, gameNumber: gameNumber)
            break
        
        case .Finish:
            //segue to UserTableViewController
            break
        }
        print(gameNumber)

    }
    
    func userSelectedNextPrime(gameNumber: GameNumber) {
        
    }
    
    func userShookPhone() {
        //check for state
        print("checking state")
        switch state {
            
        case .FindLowestPrime(let lowestPrime):
            print("FindlowestPrime")
            return
            
        case .RemoveComposites(let currentPrime):
            print("removeComposites")
            if userSelectedAllMultiples(currentPrime) {
                for index in selectedIndices {
                    print("hello")
                    gameNumbers[index].state = .Removed
                    print(index)
                }
            if isLastPrime(currentPrime) {
                highlightThePrimes()
                state = .Finish(lastPrime: theLastPrime())
                sizeOfCollection += 100
                endTheGame()
                return
            }
            selectedIndices.removeAll()
            state = .FindLowestPrime(lowestPrime: findNextPrime(currentPrime))
            ourVC!.callAlertControllerForNextPrime()
            }
        case .Finish:
            print("finish")
            return
        }
    }
    
    func findCorrespondingGameNumber(gameNumber: GameNumber) ->Int? {
        return gameNumbers.indexOf(gameNumber)
    }
    
    func selectPrime(gameNumber: GameNumber) {
        if let currentIndex = findCorrespondingGameNumber(gameNumber) {
            gameNumbers[currentIndex].state = .SelectedPrime
        }
    }
    
    func selectComposite(forPrime: Int, gameNumber: GameNumber) {
        switch state {
        case .FindLowestPrime(let lowestPrime):
                return
        case .RemoveComposites(let currentPrime):
            switch gameNumber.state {
            case .Removed:
                if gameNumber.value % currentPrime != 0 {
                    print("error")
                    ourVC!.vibrateThePhone()
                    print("\(gameNumber.value)  \(currentPrime)")
                    return
                }
                
                if let currentIndex = findCorrespondingGameNumber(gameNumber) {
                    gameNumbers[currentIndex].state = .SelectedComposite
                    selectedIndices.append(currentIndex)
                    print("Current Index \(currentIndex)")
                    print(selectedIndices)
                }
            case .Normal:
                
                if gameNumber.value % currentPrime != 0 {
                print("error")
                ourVC!.vibrateThePhone()
                print("\(gameNumber.value)  \(currentPrime)")
                return
                }
                
                if let currentIndex = findCorrespondingGameNumber(gameNumber) {
                gameNumbers[currentIndex].state = .SelectedComposite
                selectedIndices.append(currentIndex)
                print("Current Index \(currentIndex)")
                print(selectedIndices)
                }
            case .SelectedPrime:
                return
            case .SelectedComposite:
                if let currentIndex = findCorrespondingGameNumber(gameNumber) {
                    gameNumbers[currentIndex].state = .Normal
                    if let indexToBeDeleted = selectedIndices.indexOf(currentIndex){
                        selectedIndices.removeAtIndex(indexToBeDeleted)
                    }
                }
                return
            case .Unit:
                return
                
        }

        case .Finish:
            return
        }
    }
    
    func endTheGame() {
        switch state {
        case .Finish(let lastPrime):
            ourVC?.sizeOfCollection = sizeOfCollection
            ourVC?.highestPrime = lastPrime
            ourVC?.callAlertControllerForFinish()
        case .FindLowestPrime(let lowestPrime):
            ourVC?.sizeOfCollection = sizeOfCollection
            ourVC?.highestPrime = lowestPrime
            ourVC?.performSegueToUserTableViewController()
        case .RemoveComposites(let currentPrime):
            ourVC?.sizeOfCollection = sizeOfCollection
            ourVC?.highestPrime = currentPrime
            ourVC?.performSegueToUserTableViewController()
        }
    }
    
    //MARK: MathLogic
    func isPrime(currentNumber: Int) -> Bool {
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
    
    func findNextPrime(forPrime: Int) ->Int {
        for i in (forPrime + 1)...sizeOfCollection {
            if isPrime(i) {
                return i
            }
         }
        return forPrime
    }
    
    func userSelectedAllMultiples(forPrime: Int) ->Bool {
        print("userSelectedAllMultiples")
        var numberOfErrors = 0
        for var i = (forPrime * 2); i <= sizeOfCollection; i += forPrime {
            
            if numberIsNotSelected(gameNumbers[i - 1]) && !selectedIndices.contains(i - 1) {
                ++numberOfErrors
            }
        }
        if numberOfErrors > 0 {
            ourVC!.callTheAlertControllerForMissedMultiple(numberOfErrors)
            return false
        } else {
            print("true")
            return true
        }
    }
    
    func isLastPrime(forPrime: Int) -> Bool {
        let sizeOfCollectionFloat: Float = Float(sizeOfCollection)
        let highestPossible: Int = Int(sqrt((sizeOfCollectionFloat)))
        let nextPrime = findNextPrime(forPrime)
        print("comparing \(nextPrime) and \(highestPossible)")
        return nextPrime > highestPossible
    }
    
    func numberIsNotSelected(gameNumber: GameNumber) -> Bool {

        return gameNumber.state == .Normal
    }
    
    func highlightThePrimes() {
        for remainingNumber in gameNumbers {
            if numberIsNotSelected(remainingNumber) {
                if let index = findCorrespondingGameNumber(remainingNumber) {
                    gameNumbers[index].state = .SelectedPrime
                    print("\(gameNumbers[index].state)")
                }

                print("\(remainingNumber.value)")
            }
        }
    }
    
    func theLastPrime() -> Int {
        
        for (var i = sizeOfCollection; i > 0; i--) {
            if isPrime(i) {
                print("returning \(i)")
                return i
            }
        }
        return -1
    }
    

    
}