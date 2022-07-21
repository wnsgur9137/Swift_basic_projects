//
//  SettingViewController.swift
//  LEDBoard
//
//  Created by 이준혁 on 2022/07/21.
//

import UIKit

protocol LEDBoardSettingDelegate: AnyObject {
    func changedSetting(text: String?, textColor: UIColor, backgorundColor: UIColor)
}

class SettingViewController: UIViewController {

    @IBOutlet weak var txtContent: UITextField!
    @IBOutlet weak var btnYellow: UIButton!
    @IBOutlet weak var btnPurple: UIButton!
    @IBOutlet weak var btnGreen: UIButton!
    @IBOutlet weak var btnBlack: UIButton!
    @IBOutlet weak var btnBlue: UIButton!
    @IBOutlet weak var btnOrange: UIButton!
    
    weak var delegate: LEDBoardSettingDelegate?
    var ledText: String?
    var textColor: UIColor = .yellow
    var backgroundColor: UIColor = .black
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        if let ledText = self.ledText {
            self.txtContent.text = ledText
        }
        self.changeTextColor(color: self.textColor)
        self.changeBackgroundColor(color: self.backgroundColor)
    }
    
    @IBAction func tabTextColorButton(_ sender: UIButton) {
        if sender == self.btnYellow {
            self.changeTextColor(color: .yellow)
            self.textColor = .yellow
        } else if sender == self.btnPurple {
            self.changeTextColor(color: .purple)
            self.textColor = .purple
        } else {
            self.changeTextColor(color: .green)
            self.textColor = .green
        }
    }
    
    @IBAction func tabBackgroundColorButton(_ sender: UIButton) {
        if sender == self.btnBlack {
            self.changeBackgroundColor(color: .black)
            self.backgroundColor = .black
        } else if sender == self.btnBlue {
            self.changeBackgroundColor(color: .blue)
            self.backgroundColor = .blue
        } else {
            self.changeBackgroundColor(color: .orange)
            self.backgroundColor = .orange
        }
    }
    
    @IBAction func tabSaveButton(_ sender: UIButton) {
        self.delegate?.changedSetting(text: self.txtContent.text, textColor: textColor, backgorundColor: backgroundColor)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func changeTextColor(color: UIColor) {
        self.btnYellow.alpha = color == UIColor.yellow ? 1 : 0.2
        self.btnPurple.alpha = color == UIColor.purple ? 1 : 0.2
        self.btnGreen.alpha = color == UIColor.green ? 1 : 0.2
    }
    
    private func changeBackgroundColor(color: UIColor) {
        self.btnBlack.alpha = color == UIColor.black ? 1 : 0.2
        self.btnBlue.alpha = color == UIColor.blue ? 1 : 0.2
        self.btnOrange.alpha = color == UIColor.orange ? 1 : 0.2
    }
}
