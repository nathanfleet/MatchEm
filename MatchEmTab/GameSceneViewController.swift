//
//  ViewController.swift
//  MatchEmScene
//
//  Created by Nathan Fleet on 9/24/24.
//

import UIKit

class GameSceneViewController: UIViewController {
    @IBOutlet weak var pairsLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var finalScoreLabel: UILabel!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var rectangleAlpha: CGFloat = 1.0
    
    var firstClickedRectangle: UIButton?
    
    var rectangleTimer: Timer?
    var gameTimer: Timer?
    var paused: Bool = false
    
    var timeRemaining: Int = 12
    var record: Int = 0
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
    var tag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playAgainButton.isHidden = true
        finalScoreLabel.isHidden = true
        recordLabel.isHidden = true
    }
    
    
    @IBAction func startGameButtonPressed(_ sender: UIButton) {
        sender.removeFromSuperview()
        titleLabel.removeFromSuperview()
        startGame()
    }
    
    @IBAction func playAgainButtonPressed(_ sender: UIButton) {
        updateLabels()
        firstClickedRectangle = nil
        sender.isHidden = true
        finalScoreLabel.isHidden = true
        recordLabel.isHidden = true
        startGame()
    }
    
    @objc func rectangleClicked(_ rectangle: UIButton) {
        if firstClickedRectangle == nil {
            firstClickedRectangle = rectangle
            UIView.animate(withDuration: 0.3) {
                rectangle.layer.borderWidth = 5
                rectangle.layer.borderColor = UIColor.white.cgColor
            }
        } else if firstClickedRectangle?.tag == rectangle.tag && firstClickedRectangle != rectangle {
            score += 1
            updateLabels()
            UIView.animate(withDuration: 0.3, animations: {
                self.firstClickedRectangle?.alpha = 0
                rectangle.alpha = 0
            }) {_ in
                self.firstClickedRectangle?.removeFromSuperview()
                rectangle.removeFromSuperview()
                self.firstClickedRectangle = nil
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                rectangle.layer.borderWidth = 0
                self.firstClickedRectangle?.layer.borderWidth = 0
                self.firstClickedRectangle = nil
            }
        }
        
    }
    
    @objc func drawRectangles() {
        let pair = generateRectanglePair()
        for rect in pair { self.view.addSubview(rect) }
        pairs += 1
        updateLabels()
    }
    
    func generateRectanglePair() -> [UIButton] {
        var rectangles: [UIButton] = []
        
        let randomWidth = CGFloat.random(in: 50...100)
        let randomHeight = CGFloat.random(in: 50...100)
        let randomSize = CGSize(width: randomWidth, height: randomHeight)
        let randomColor = UIColor(
            red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: gameModel.rectangleAlpha
        )
        
        for _ in 0..<2{
            let rectangle = UIButton()
            var frame: CGRect
            let x = CGFloat.random(in: self.view.frame.minX...(self.view.frame.maxX - randomWidth))
            let y = CGFloat.random(in: 77...(self.view.frame.maxY - randomHeight - self.view.safeAreaInsets.bottom))
            frame = CGRect(origin: CGPoint(x: x, y: y), size: randomSize)
                        
            rectangle.frame = frame
            rectangle.backgroundColor = randomColor
            rectangle.tag = tag
            rectangle.addTarget(self, action: #selector(rectangleClicked(_:)), for: .touchUpInside)
            rectangles.append(rectangle)
        }
        tag += 1
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
    
    func pause() {
        gameModel.paused = true
        rectangleTimer?.invalidate()
        gameTimer?.invalidate()
    }
    
    func resume() {
        gameModel.paused = false
        startGame()
    }
    
    func endGame() {
        rectangleTimer?.invalidate()
        rectangleTimer = nil
        
        gameTimer?.invalidate()
        gameTimer = nil
        
        // remove remaining rectangles
        for subview in self.view.subviews {
            if subview != playAgainButton
                && subview != pairsLabel
                && subview != timeLabel
                && subview != scoreLabel
                && subview != recordLabel
                && subview != finalScoreLabel {
                subview.removeFromSuperview()
            }
        }
        
        record = max(score, record)
        
        recordLabel.text = "RECORD: \(record)"
        finalScoreLabel.text = "FINAL SCORE: \(score)"
        finalScoreLabel.isHidden = false
        recordLabel.isHidden = false
        
        score = 0
        timeRemaining = 12
        pairs = 0
        
        playAgainButton.isHidden = false
    }
    
    func updateLabels() {
        timeLabel.text = "TIME: \(timeRemaining)s"
        scoreLabel.text = "SCORE: \(score)"
        pairsLabel.text = "PAIRS: \(pairs)"
    }
}
