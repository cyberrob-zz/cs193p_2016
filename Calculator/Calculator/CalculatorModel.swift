//
//  CalculatorModel.swift
//  Calculator
//
//  Created by Bo Wen Wang on 2016/10/8.
//  Copyright © 2016年 Bo Wen Wang. All rights reserved.
//

import Foundation

class CalculatorModel {
    
    var description:String? = nil
    
    //whether there is a binary operation pending
    lazy var isPartialResult = false
    
    private var accumulator = 0.0
    
   
    
    
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
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Clear:
                accumulator = 0.0
                pending = nil
                description = nil
            case .Constant(let associatedValue):
                accumulator = associatedValue
            case .UnaryOperation(let associatedFunction):
                accumulator = associatedFunction(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
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
