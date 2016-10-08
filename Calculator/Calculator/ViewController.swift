//
//  ViewController.swift
//  Calculator
//
//  Created by Bo Wen Wang on 2016/10/8.
//  Copyright © 2016年 Bo Wen Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var resultDisplay: UILabel!
    
    var isCurrentlyTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if isCurrentlyTyping {
            resultDisplay.text = resultDisplay.text! + digit
        } else {
            resultDisplay.text = digit
        }
        isCurrentlyTyping = true
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        isCurrentlyTyping = false
        if let mathSymbol = sender.currentTitle {
            if mathSymbol == "π" {
                resultDisplay.text = String(M_PI)
            }
        }
    }
}

