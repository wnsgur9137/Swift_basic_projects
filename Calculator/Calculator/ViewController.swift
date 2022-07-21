//
//  ViewController.swift
//  Calculator
//
//  Created by 이준혁 on 2022/07/21.
//

import UIKit

enum Operation {
    case Add
    case Subtract
    case Divide
    case Multiply
    case unknown
}

class ViewController: UIViewController {

    @IBOutlet weak var lblOutput: UILabel!
    
    var displayNumber = ""  // 계산기 버튼을 누를 때마다 lblOutput에 표시될 숫자
    var firstOperand = ""   // 이전 계산 값을 저장하는 프로퍼티 (첫 번재 피연산자)
    var secondOperand = ""  // 새롭게 입력된 값을 저장하는 프로퍼티 (두 번째 피연산자)
    var result = ""         // 계산의 결과 값을 저장하는 프로퍼티
    var currentOperation: Operation = .unknown  // 현재 계산기에 어떤 연산자가 입력되었는지 저장
    
    let displayNumberCount = 9
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tabNumberButton(_ sender: UIButton) {
        guard let numberValue = sender.title(for: .normal) else { return }    // 옵셔널 타입이므로 guard
        if self.displayNumber == "0" && numberValue == "0" {
            return
        }
        if self.displayNumber.count < displayNumberCount {   // 9자리의 숫자까지 입력 가능
            if self.displayNumber == "0" {
                self.displayNumber = numberValue
                self.lblOutput.text = self.displayNumber
            } else {
                self.displayNumber += numberValue
                self.lblOutput.text = self.displayNumber
            }
        }
    }
    
    @IBAction func tabClearButton(_ sender: UIButton) {
        self.displayNumber = ""
        self.firstOperand = ""
        self.secondOperand = ""
        self.result = ""
        self.currentOperation = .unknown
        self.lblOutput.text = "0"
    }
    
    @IBAction func tabDotButton(_ sender: UIButton) {
        if self.displayNumber.count < (displayNumberCount - 1) && !self.displayNumber.contains(".") {    // . 중복 X
            self.displayNumber += self.displayNumber.isEmpty ? "0." : "."
            self.lblOutput.text = self.displayNumber
        }
    }
    
    @IBAction func tabDivideButton(_ sender: UIButton) {
        self.operation(.Divide)
    }
    
    @IBAction func tabMultiplyButton(_ sender: UIButton) {
        self.operation(.Multiply)
    }
    
    @IBAction func tabSubtractButton(_ sender: UIButton) {
        self.operation(.Subtract)
    }
    
    @IBAction func tabAddButton(_ sender: UIButton) {
        self.operation(.Add)
    }
    
    @IBAction func tabEqualButton(_ sender: UIButton) {
        self.operation(self.currentOperation)
    }
    
    func operation(_ operation: Operation) {
        if self.currentOperation != .unknown {
            if !self.displayNumber.isEmpty {
                self.secondOperand = self.displayNumber
                self.displayNumber = ""
                
                guard let firstOperand = Double(self.firstOperand) else { return }
                guard let secondOperand = Double(self.secondOperand) else { return }
                
                print("firstOperand = \(firstOperand)\nsecondOperand = \(secondOperand)")
                
                switch self.currentOperation {
                case .Add:
                    self.result = "\(firstOperand + secondOperand)"
                case .Subtract:
                    self.result = "\(firstOperand - secondOperand)"
                case .Divide:
                    self.result = "\(firstOperand / secondOperand)"
                case .Multiply:
                    self.result = "\(firstOperand * secondOperand)"
                default:
                    break
                }
                
                // 1로 나누었을 때 나머지가 0일 경우 소수점 표시 X
                if let result = Double(self.result), result.truncatingRemainder(dividingBy: 1) == 0 {
                    self.result = "\(Int(result))"
                }
                
                self.firstOperand = self.result
                self.lblOutput.text = self.result
            }
            
            self.currentOperation = operation
        } else {
            self.firstOperand = self.displayNumber
            self.currentOperation = operation
            self.displayNumber = ""
        }
    }
}

