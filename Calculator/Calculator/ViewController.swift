//
//  ViewController.swift
//  Calculator
//
//  Created by Bo Wen Wang on 2016/10/8.
//  Copyright © 2016年 Bo Wen Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var resultDisplay: UILabel!
    private var isCurrentlyTyping = false
    private var model = CalculatorModel()
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if isCurrentlyTyping {
            resultDisplay.text = resultDisplay.text! + digit
        } else {
            resultDisplay.text = digit
        }
        isCurrentlyTyping = true
    }
    
    private var displayValue: Double {
        get {
            return Double(resultDisplay.text!)!
        }
        set {
            resultDisplay.text = String(newValue)
        }
    }
    
    @IBAction private func performOperation(_ sender: UIButton) {
        if isCurrentlyTyping {
            model.setOperand(operand: displayValue)
            isCurrentlyTyping = false
        }
        
        if let mathSymbol = sender.currentTitle {
            model.performOperation(symbol: mathSymbol)
        }
        
        displayValue = model.result
    }
}

