//
//  RoundButton.swift
//  Calculator
//
//  Created by 이준혁 on 2022/07/21.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {
    @IBInspectable var isRound: Bool = false {
        didSet {
            if isRound {
                self.layer.cornerRadius = self.frame.height / 2
            }
        }
    }
}
