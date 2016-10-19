//
//  CalculatorModel.swift
//  Calculator
//
//  Created by Bo Wen Wang on 2016/10/8.
//  Copyright © 2016年 Bo Wen Wang. All rights reserved.
//

import Foundation

class CalculatorModel {
    private var accumulator = 0.0
    
    let waitingSign = " ..."
    let equalSign = " = \n"
    
    private var description: String? = nil
    
    func setDescription(newDescription: String) {
        print("New Description: \(newDescription)")
        if description == nil {
            description = newDescription
        } else {
            if isPartialResult {
                if (operations[newDescription] != nil) {
                    description = description!.appending(" " + newDescription + " ").appending(waitingSign)
                } else {
                    if description!.range(of: waitingSign) != nil {
                        description = description!.replacingOccurrences(of: waitingSign, with: newDescription)
                    } else {
                        description =
                            description!.appending(String(newDescription.characters.last!))
                    }
                }
                
            } else {
                if newDescription == "=" {
                    description = description! + equalSign
                } else {
                    description = newDescription
                }
                if pending != nil {
                    description = description!.replacingOccurrences(of: waitingSign, with: newDescription)
                } else {
                    description = description!.replacingOccurrences(of: waitingSign, with: equalSign)
                }
            }
        }
        
        print("Description: \(description!)")
    }
    
    func getDescription() -> String? {
        return description
    }
    
    //whether there is a binary operation pending
    private var isPartialResult = false
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    private var operations: Dictionary<String, Operation> = [
        "AC" : Operation.Clear,
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "−" : Operation.BinaryOperation({ $0 - $1 }),
        "÷" : Operation.BinaryOperation({ $0 / $1 }),
        "×" : Operation.BinaryOperation({ $0 * $1 }),
        "." : Operation.BinaryOperation({ return $0 + ( $1 / 10) }),
        "=" : Operation.Equals,
        "∛" : Operation.UnaryOperation({ pow($0, 1/3) }),
        "±" : Operation.UnaryOperation({ -$0 }),
    ]
    
    private enum Operation {
        case Clear
        case Constant(Double)
        case UnaryOperation((Double)-> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func resetAllParams() {
        accumulator = 0.0
        pending = nil
        description = nil
        isPartialResult = false
        print("All Params are reset!")
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Clear:
                resetAllParams()
            case .Constant(let associatedValue):
                accumulator = associatedValue
            case .UnaryOperation(let associatedFunction):
                accumulator = associatedFunction(accumulator)
            case .BinaryOperation(let function):
                isPartialResult = true
                setDescription(newDescription: symbol)
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                isPartialResult = false
                setDescription(newDescription: symbol)
                executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    // Declar a struct for holding first operand and binary function until EQUALS clicked
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    
}
