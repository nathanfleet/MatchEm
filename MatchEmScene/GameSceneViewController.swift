//
//  ViewController.swift
//  MatchEmScene
//
//  Created by Nathan Fleet on 9/24/24.
//

import UIKit

class ViewController: UIViewController {
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func startGameButtonPressed(_ sender: UIButton) {
        startGame()
        sender.removeFromSuperview()
    }
    
    @objc func drawRectangles () {
        let pair = generateRectanglePair()
        for rect in pair {
            self.view.addSubview(rect)
        }
    }
    
    func generateRectanglePair() -> [UIButton] {
        var rectangles: [UIButton] = []
        
        // could maybe use a global static variable to ensure no two future
        // pairs randomly have the same tag? idk
        let tag = Int.random(in: 1...1000)
        
        let randomWidth = CGFloat.random(in: 50...150)
        let randomHeight = CGFloat.random(in: 50...150)
        let randomSize = CGSize(width: randomWidth, height: randomHeight)
        let randomColor = UIColor(
            red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: 1.0
        )
        
        for _ in 0..<2{
            let rectangle = UIButton()
            // x, y from RandomRect
            let x = CGFloat.random(in: self.view.frame.minX...(self.view.frame.maxX - randomWidth))
            let y = CGFloat.random(in: self.view.safeAreaInsets.top...(self.view.frame.maxY - randomHeight - self.view.safeAreaInsets.bottom))
            rectangle.frame.size = randomSize
            rectangle.backgroundColor = randomColor
            rectangle.frame.origin = CGPoint(x: x, y: y)
            rectangle.tag = tag
            rectangles.append(rectangle)
        }
        return rectangles
    }
    
    func startGame() {
        // need a running timer ... when timer reaches 12 seconds kill the game
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(drawRectangles), userInfo: nil, repeats: true)
    }
}

