//
//  ViewController.swift
//  LEDBoard
//
//  Created by 이준혁 on 2022/07/21.
//

import UIKit

class ViewController: UIViewController, LEDBoardSettingDelegate {

    @IBOutlet weak var lblContent: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblContent.textColor = .yellow
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let settingController = segue.destination as? SettingViewController {
            settingController.delegate = self
            settingController.ledText = self.lblContent.text
            settingController.textColor = self.lblContent.textColor
            settingController.backgroundColor = self.view.backgroundColor ?? .black
        }
    }

    func changedSetting(text: String?, textColor: UIColor, backgorundColor: UIColor) {
        if let text = text {
            self.lblContent.text = text
        }
        self.lblContent.textColor = textColor
        self.view.backgroundColor = backgorundColor
    }
}

