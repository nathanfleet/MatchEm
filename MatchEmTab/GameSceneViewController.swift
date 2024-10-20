//
//  GameSceneViewController.swift
//  MatchEmScene
//
//  Created by Nathan Fleet on 9/24/24.
//

import UIKit
class GameSceneViewController: UIViewController {

    // Game State
    var gameInProgress = false
    var gameRunning = false
    var paused: Bool = false
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
    var tag = 0

    // UI Elements
    @IBOutlet weak var pairsLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var finalScoreLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    var rectangleTimer: Timer?
    var gameTimer: Timer?

    var firstClickedRectangle: UIButton?

    // View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        finalScoreLabel.isHidden = true
        timeRemaining = GameManager.shared.gameDuration
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if gameInProgress && !gameRunning {
            resume()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if gameInProgress {
            pause()
        }
    }

    //Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if event?.allTouches?.count == 2 {
            if !gameInProgress {
                startGame()
            } else {
                if gameRunning {
                    pause()
                } else {
                    resume()
                }
            }
        }
    }

    //Game Control Methods

    func startGame(resetTime: Bool = true) {
        if resetTime {
            timeRemaining = GameManager.shared.gameDuration
        }
        updateLabels()
        gameInProgress = true
        gameRunning = true
        finalScoreLabel.isHidden = true
        titleLabel.isHidden = true

        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        rectangleTimer = Timer.scheduledTimer(timeInterval: TimeInterval(1.0 / GameManager.shared.rectangleAppearanceSpeed), target: self, selector: #selector(drawRectangles), userInfo: nil, repeats: true)
    }

    func pause() {
        rectangleTimer?.invalidate()
        gameTimer?.invalidate()
        gameRunning = false
    }

    func resume() {
        gameRunning = true
        startGame(resetTime: false)
    }

    func endGame() {
        rectangleTimer?.invalidate()
        rectangleTimer = nil

        gameTimer?.invalidate()
        gameTimer = nil

        finalScoreLabel.isHidden = false
        titleLabel.isHidden = false

        GameManager.shared.addScore(score)

        // Remove remaining rectangles
        for subview in self.view.subviews {
            if subview != pairsLabel
                && subview != timeLabel
                && subview != scoreLabel
                && subview != finalScoreLabel
                && subview != titleLabel {
                subview.removeFromSuperview()
            }
        }

        finalScoreLabel.text = "FINAL SCORE: \(score)"
        finalScoreLabel.isHidden = false

        gameInProgress = false
        gameRunning = false

        score = 0
        timeRemaining = GameManager.shared.gameDuration
        pairs = 0
    }

    // Timer Methods
    @objc func updateTime() {
        timeRemaining -= 1
        updateLabels()

        if timeRemaining <= 0 {
            endGame()
        }
    }

    // Rectangle Handling
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
        var randomColor: UIColor

        let colorOption = GameManager.shared.rectangleColorOption
        switch colorOption {
        case 0:
            // All colors
            randomColor = UIColor(
                red: CGFloat.random(in: 0...1),
                green: CGFloat.random(in: 0...1),
                blue: CGFloat.random(in: 0...1),
                alpha: 1.0
            )
        case 1:
            // No blue component
            randomColor = UIColor(
                red: CGFloat.random(in: 0...1),
                green: CGFloat.random(in: 0...1),
                blue: 0,
                alpha: 1.0
            )
        case 2:
            // Shades of gray
            let gray = CGFloat.random(in: 0...1)
            randomColor = UIColor(
                red: gray,
                green: gray,
                blue: gray,
                alpha: 1.0
            )
        default:
            randomColor = UIColor(
                red: CGFloat.random(in: 0...1),
                green: CGFloat.random(in: 0...1),
                blue: CGFloat.random(in: 0...1),
                alpha: 1.0
            )
        }

        for _ in 0..<2 {
            let rectangle = UIButton()
            var frame: CGRect

            let labelsMaxY = max(pairsLabel.frame.maxY, scoreLabel.frame.maxY, timeLabel.frame.maxY)
            let minY = labelsMaxY + 10
            let maxY = view.frame.maxY - randomHeight - view.safeAreaInsets.bottom
            let minX = view.frame.minX
            let maxX = view.frame.maxX - randomWidth

            var x: CGFloat
            var y: CGFloat

            repeat {
                x = CGFloat.random(in: minX...maxX)
                y = CGFloat.random(in: minY...maxY)
                frame = CGRect(origin: CGPoint(x: x, y: y), size: randomSize)
            } while !GameManager.shared.allowOverlap && isOverlapping(rect: frame)

            rectangle.frame = frame
            rectangle.backgroundColor = randomColor
            rectangle.tag = tag
            rectangle.addTarget(self, action: #selector(rectangleClicked(_:)), for: .touchUpInside)

            rectangles.append(rectangle)
        }
        tag += 1
        return rectangles
    }

    func isOverlapping(rect: CGRect) -> Bool {
        for subview in view.subviews {
            if let rectangle = subview as? UIButton, rectangle != firstClickedRectangle {
                if rectangle.frame.intersects(rect) {
                    return true
                }
            }
        }
        return false
    }

    @objc func rectangleClicked(_ rectangle: UIButton) {
        if gameRunning {
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
                }) { _ in
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
    }

    // Helper Methods
    func updateLabels() {
        timeLabel.text = "TIME: \(timeRemaining)s"
        scoreLabel.text = "SCORE: \(score)"
        pairsLabel.text = "PAIRS: \(pairs)"
    }
}
