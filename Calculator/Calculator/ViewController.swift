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
    @IBOutlet weak var descriptionLabel: UILabel!
    private var isCurrentlyTyping = false
    private var model = CalculatorModel()
    private var digitAfterDecimalPoint = 0.0
    private var isDecimalPointClicked = false
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if isCurrentlyTyping {
            if(digit == ".") {
                isDecimalPointClicked = true
                print("Decimal point clicked")
            } else {
                if isDecimalPointClicked {
                    digitAfterDecimalPoint += 1
                    print("digit after decimal point \(digitAfterDecimalPoint)")
                    resultDisplay.text =
                        String(displayValue + Double(digit)! / Double(pow(10.0, digitAfterDecimalPoint)))
                } else {
                    resultDisplay.text = resultDisplay.text! + digit
                }
            }
        } else {
            resultDisplay.text = digit
        }
        
        // Put digit into description
        if model.description == nil {
            model.description = resultDisplay.text!
        } else {
            model.description = model.description! + resultDisplay.text!
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
        
        isDecimalPointClicked = false
        digitAfterDecimalPoint = 0
        //print("digit after decimal point \(digitAfterDecimalPoint)")
        
        if let mathSymbol = sender.currentTitle {
            if model.description != nil {
                if mathSymbol != "AC" {
                    model.description = model.description! + "\(" ")" + mathSymbol
                } else {
                    model.description = nil
                }
            }
            model.performOperation(symbol: mathSymbol)
        }
        descriptionLabel.text = model.description ?? "description"
        displayValue = model.result
    }
}

