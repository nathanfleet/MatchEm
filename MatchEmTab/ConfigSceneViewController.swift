//
//  ConfigScene.swift
//  MatchEmTab
//
//  Created by Nathan Fleet on 10/17/24.
//

import UIKit

class ConfigSceneViewController: UIViewController {
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var alphaSwitch: UISwitch!
    @IBOutlet weak var colorSegmentedControl: UISegmentedControl!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationStepper: UIStepper!
    @IBOutlet weak var recordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speedSlider.minimumValue = 0.5
        speedSlider.maximumValue = 2.0
        speedSlider.value = 1.0
        speedLabel.text = "Speed: \(speedSlider.value)x"
        
        colorSegmentedControl.selectedSegmentIndex = GameManager.shared.rectangleColorOption
        
        durationStepper.value = Double(GameManager.shared.gameDuration)
        durationLabel.text = "Game Duration: \(Int(durationStepper.value))s"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateHighScoresLabel()
    }
    
    @IBAction func durationStepperChanged(_ s: UIStepper) {
        GameManager.shared.gameDuration = Int(s.value)
        durationLabel.text = "Game Duration: \(Int(s.value))s"
    }
    
    @IBAction func colorOptionChanged(_ s: UISegmentedControl) {
        GameManager.shared.rectangleColorOption = s.selectedSegmentIndex
    }
    
    @IBAction func alphaSwitchChanged(_ s: UISwitch) {
        GameManager.shared.rectangleAlpha = s.isOn ? 1.0 : 0.5
    }
    
    @IBAction func speedSliderChanged(_ s: UISlider) {
        let selectedSpeed = s.value
        speedLabel.text = "Speed: \(String(format: "%.1f", selectedSpeed))x"
        GameManager.shared.rectangleAppearanceSpeed = selectedSpeed
    }
    
    func updateHighScoresLabel() {
        let scores = GameManager.shared.highScores
        recordLabel.text = "High Scores:\n"
        for (index, score) in scores.enumerated() {
            recordLabel.text! += "\(index + 1): \(score)\n"
        }
    }
}
