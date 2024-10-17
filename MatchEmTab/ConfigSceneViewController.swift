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

    override func viewDidLoad() {
        super.viewDidLoad()
        speedSlider.minimumValue = 0.5
        speedSlider.maximumValue = 2.0
        speedSlider.value = 1.0
        speedLabel.text = "Speed: \(speedSlider.value)x"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gameModel.paused = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gameModel.paused = false
    }
    
    @IBAction func alphaSwitchChanged(_ s: UISwitch) {
        if s.isOn {
            gameModel.rectangleAlpha = 1.0
        } else {
            gameModel.rectangleAlpha = 0.5
        }
    }
    
    @IBAction func speedSliderChanged(_ s: UISlider) {
        let selectedSpeed = s.value
        speedLabel.text = "Speed: \(String(format: "%.1f", selectedSpeed))x"
    }
}
