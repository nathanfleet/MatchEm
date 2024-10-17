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
    
    var gameSceneVC: GameSceneViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        speedSlider.minimumValue = 0.5
        speedSlider.maximumValue = 2.0
        speedSlider.value = 1.0
        speedLabel.text = "Speed: \(speedSlider.value)x"
    }
    
    @IBAction func alphaSwitchChanged(_ s: UISwitch) {
        if s.isOn {
            // gameSceneVC?.rectangleAlpha = 1.0
        } else {
            // gameSceneVC?.rectangleAlpha = 0.5
        }
    }
    
    @IBAction func speedSliderChanged(_ s: UISlider) {
        let selectedSpeed = s.value
        speedLabel.text = "Speed: \(String(format: "%.1f", selectedSpeed))x"
    }
}
