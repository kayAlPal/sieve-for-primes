//
//  GameNumber.swift
//  SieveOfEratosthenes
//
//  Created by Kelly Alonso-Palt on 11/18/15.
//  Copyright © 2015 Kelly Alonso. All rights reserved.
//

import Foundation




enum GameNumberState {
    
    case normal //white
    case selectedPrime //yellow, primes found by user
    case selectedComposite //red, composites found by user are red
    case shaker
    case removed //gray, removed composites after user finds all composites in 
    case unit
   
}

struct GameNumber: Equatable {
    var value: Int
    var state: GameNumberState

    
    init (number: Int) {

        value = number
        if value == 1 {
            state = .unit
        } else {
            state =  .normal
        }
        
    }
    
 
}

func ==(rhs: GameNumber, lhs: GameNumber) ->Bool {
    
    return rhs.value == lhs.value
    
}
