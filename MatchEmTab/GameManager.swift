//
//  GameManager.swift
//  MatchEmTab
//
//  Created by Nathan Fleet on 10/19/24.
//

import UIKit

class GameManager {
    static let shared = GameManager()
    
    private init() { }
    
    private(set) var highScores: [Int] = []
    
    func addScore(_ score: Int) {
        highScores.append(score)
        highScores.sort(by: >)
        if highScores.count > 3 {
            highScores = Array(highScores.prefix(3))
        }
    }
    
    var rectangleAppearanceSpeed: Float = 1.0
    var allowOverlap: Bool = true
    var rectangleColorOption: Int = 0
    var gameDuration: Int = 12
}

