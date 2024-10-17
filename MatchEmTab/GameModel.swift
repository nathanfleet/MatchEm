//
//  GameModel.swift
//  MatchEmTab
//
//  Created by Nathan Fleet on 10/17/24.
//

import Foundation

class GameModel {    
    var score: Int = 0
    var pairs: Int = 0
    var timeRemaining: Int = 12
    var record: Int = 0
    var rectangleAlpha: CGFloat = 1.0
    var paused: Bool = false
    
    func resetGame() {
        score = 0
        pairs = 0
        timeRemaining = 12
        paused = false
    }
}
