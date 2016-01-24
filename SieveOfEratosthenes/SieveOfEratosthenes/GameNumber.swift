//
//  GameNumber.swift
//  SieveOfEratosthenes
//
//  Created by Kelly Alonso-Palt on 11/18/15.
//  Copyright © 2015 Kelly Alonso. All rights reserved.
//

import Foundation




enum GameNumberState {
    
    case Normal //white
    case SelectedPrime //yellow, primes found by user
    case SelectedComposite //red, composites found by user are red
    case Removed //gray, removed composites after user finds all composites in 
    case Unit
   
}

struct GameNumber: Equatable {
    var value: Int
    var state: GameNumberState

    
    init (number: Int) {

        value = number
        if value == 1 {
            state = .Unit
        } else {
            state =  .Normal
        }
        
    }
    
 
}

func ==(rhs: GameNumber, lhs: GameNumber) ->Bool {
    
    return rhs.value == lhs.value
    
}