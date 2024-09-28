//
//  ViewController.swift
//  MatchEmScene
//
//  Created by Nathan Fleet on 9/24/24.
//

import UIKit

// TODO: Add labels to display counts and scores
class ViewController: UIViewController {
    @IBOutlet weak var pairsLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    
    var firstClickedRectangle: UIButton?
    var rectangleTimer: Timer?
    var gameTimer: Timer?
    var timeRemaining: Int = 12
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "SCORE: \(score)"
        }
    }
    var pairs: Int = 0 {
        didSet {
            pairsLabel.text = "PAIRS: \(pairs)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playAgainButton.isHidden = true
    }
    
    
    @IBAction func startGameButtonPressed(_ sender: UIButton) {
        sender.removeFromSuperview()
        startGame()
    }
    
    @IBAction func playAgainButtonPressed(_ sender: UIButton) {
        updateLabels()
        firstClickedRectangle = nil
        sender.isHidden = true
        startGame()
    }
    
    @objc func drawRectangles() {
        let pair = generateRectanglePair()
        for rect in pair { self.view.addSubview(rect) }
        pairs += 1
        updateLabels()
    }

    // TODO: make the highlight more appealing
    // TODO: make the matched rectangles dissappear with animationm
    @objc func rectangleClicked(_ sender: UIButton) {
        if firstClickedRectangle == nil {
            firstClickedRectangle = sender
            sender.layer.borderWidth = 5
            sender.layer.borderColor = UIColor.white.cgColor
        } else if firstClickedRectangle?.tag == sender.tag && firstClickedRectangle != sender {
            score += 1
            updateLabels()
            firstClickedRectangle?.removeFromSuperview()
            sender.removeFromSuperview()
            firstClickedRectangle = nil
        } else {
            sender.layer.borderWidth = 0
            firstClickedRectangle?.layer.borderWidth = 0
            firstClickedRectangle = nil
        }
        
    }
    
    func generateRectanglePair() -> [UIButton] {
        var rectangles: [UIButton] = []
        
        // TODO: use a global static variable instead
        let tag = Int.random(in: 1...1000)
        
        let randomWidth = CGFloat.random(in: 50...100)
        let randomHeight = CGFloat.random(in: 50...100)
        let randomSize = CGSize(width: randomWidth, height: randomHeight)
        let randomColor = UIColor(
            red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: 1.0
        )
        
        for _ in 0..<2{
            let rectangle = UIButton()
            var overlap: Bool
            var frame: CGRect
            repeat {
                let x = CGFloat.random(in: self.view.frame.minX...(self.view.frame.maxX - randomWidth))
                let y = CGFloat.random(in: self.view.safeAreaInsets.top...(self.view.frame.maxY - randomHeight - self.view.safeAreaInsets.bottom))
                frame = CGRect(origin: CGPoint(x: x, y: y), size: randomSize)
                overlap = false
                for subview in self.view.subviews {
                    if frame.intersects(subview.frame) {
                        overlap = true
                        break
                    } else if !rectangles.isEmpty {
                        if frame.intersects(rectangles[0].frame) {
                            overlap = true
                            break
                        }
                    }
                }
            } while overlap
                        
            rectangle.frame = frame
            rectangle.backgroundColor = randomColor
            rectangle.tag = tag
            rectangle.addTarget(self, action: #selector(rectangleClicked(_:)), for: .touchUpInside)
            rectangles.append(rectangle)
        }
        return rectangles
    }
    
    func startGame() {
        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        rectangleTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(drawRectangles), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        timeRemaining -= 1
        updateLabels()
        
        if timeRemaining <= 0 {
            endGame()
        }
    }
    
    func endGame() {
        rectangleTimer?.invalidate()
        rectangleTimer = nil
        
        gameTimer?.invalidate()
        gameTimer = nil
        
        timeRemaining = 12
        score = 0
        pairs = 0
        
        for subview in self.view.subviews {
            if subview != playAgainButton
                && subview != pairsLabel
                && subview != timeLabel
                && subview != scoreLabel {
                subview.removeFromSuperview()
            }
        }
        
        playAgainButton.isHidden = false
    }
    
    func updateLabels() {
        timeLabel.text = "TIME: \(timeRemaining)s"
        scoreLabel.text = "SCORE: \(score)"
        pairsLabel.text = "PAIRS: \(pairs)"
    }
}
