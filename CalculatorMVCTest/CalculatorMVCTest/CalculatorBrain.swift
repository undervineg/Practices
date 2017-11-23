//
//  Model.swift
//  CalculatorMVCTest
//
//  Created by 심 승민 on 2017. 10. 8..
//  Copyright © 2017년 심 승민. All rights reserved.
//

import Foundation

class CalculatorBrain{
    
    private var accumulate: Double = 0.0
    
    private var internalProgram = [AnyObject]()
    
    
    func setOperand(value: Double){
        accumulate = value
        internalProgram.append(value as AnyObject)
        print(accumulate)
    }
    
    private enum Operation {
        case Constant(Double)
        case UrinaryOperation((Double)->Double)
        case BinaryOperation((Double, Double)->Double)
        case Equals
        case Clear
    }
    
    private let operations: [String : Operation] = [
        "π" : Operation.Constant(Double.pi),
        "e" : Operation.Constant(M_E),
        "±" : Operation.UrinaryOperation({ -$0 }),
        "√" : Operation.UrinaryOperation(sqrt),
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "-" : Operation.BinaryOperation({ $0 - $1 }),
        "×" : Operation.BinaryOperation({ $0 * $1 }),
        "÷" : Operation.BinaryOperation({ $0 / $1 }),
        "=" : Operation.Equals,
        "AC": Operation.Clear
    ]
    
    func performOperation(symbol: String){
        print("performOperation")
        internalProgram.append(symbol as AnyObject)
        // 딕셔너리는 key에 해당하는 값이 없을 수도 있으므로 옵셔널 타입이다.
        if let operation = operations[symbol]{
            switch operation {
            case .Constant(let value):
                accumulate = value
            case .UrinaryOperation(let function):
                accumulate = function(accumulate)
            case .BinaryOperation(let function) :
                executePendingOperation()
                pending = pendingOperationInfo(firstOperand: accumulate, operation: function)
            case .Equals :
                executePendingOperation()
            case .Clear :
                clear()
            }
        }
    }
    
    
    private struct pendingOperationInfo {
        var firstOperand: Double
        var operation: (Double, Double)->Double
    }
    
    private var pending: pendingOperationInfo?
    
    private func executePendingOperation(){
        if pending != nil{
            accumulate = pending!.operation(pending!.firstOperand, accumulate)
            pending = nil
        }
        // pending이 nil이면 실행 안됨
    }
    
    
    func clear(){
        accumulate = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        get{
            // brain에서 행한 값들을 저장
            return internalProgram as CalculatorBrain.PropertyList
        }
        set{
            // 외부에서 받은 값들을 brain에 세팅
            clear()
            if let arrayOfOps = newValue as? [AnyObject]{
                for op in arrayOfOps{
                    if let operand = op as? Double{
                        setOperand(value: operand)
                    }
                    if let operation = op as? String{
                        performOperation(symbol: operation)
                    }
                }
            }
        }
    }
    
    
    
    var result: Double {
        get{
            print("result: ", accumulate)
            return accumulate
        }
    }
    
}
