//
//  ViewController.swift
//  CalculatorMVCTest
//
//  Created by 심 승민 on 2017. 10. 8..
//  Copyright © 2017년 심 승민. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var lbDisplay: UILabel!
    
    // model은 AppDelegate에서 관리. 따라서 해당 데이터를 VC에서 사용하기 위해 delegate를 공유받는다.
    private let delegate = UIApplication.shared.delegate as! AppDelegate
    
    private var userIsTypingDigit: Bool = false
    
    private var displayText: Double{
        get{
            return Double(lbDisplay.text!)!
        }
        set{
            lbDisplay.text = String(newValue)
        }
    }
    
    private var brain: CalculatorBrain?
    
    override func viewDidLoad() {
        guard let brain = delegate.brain else { return }
        
        // 화면이 로드되면 이전에 앱에서 계산하다 중단된 결과를 보여줌
        if let storedProgram = UserDefaults.standard.object(forKey: "program"){
            // saved한 program이 있으면, brain에 넘김
            brain.program = storedProgram as CalculatorBrain.PropertyList
            // brain은 이를 받아 계산하여 brain.result에 저장함
            displayText = brain.result
        }
        
    }
    
    
    @IBAction func pressDigit(_ sender: UIButton) {
        let digit: String = sender.currentTitle!
        let textCurrentlyOnDisplay: String = lbDisplay.text!
        
        if userIsTypingDigit{
            if digit == "." {
                // "."은 디스플레이 라벨에 1개만 노출 가능
                if !textCurrentlyOnDisplay.contains("."){
                    lbDisplay.text = textCurrentlyOnDisplay + digit
                }
            }else if textCurrentlyOnDisplay != "0"{
                // "0"의 연속 노출을 방지
                lbDisplay.text = textCurrentlyOnDisplay + digit
            }
        }else{
            if digit == "."{
                // 처음 누른 버튼이 "."인 경우, 기존에 있던 0에 붙여서 노출 ex) 0.
                if !textCurrentlyOnDisplay.contains("."){
                    lbDisplay.text = textCurrentlyOnDisplay + digit
                }
            }else{
                lbDisplay.text = digit
            }
        }
        
        userIsTypingDigit = true
    }
    
    
    @IBAction func pressOperator(_ sender: UIButton) {
        guard let brain = delegate.brain, let mathmeticalSymbol = sender.currentTitle else { return }
        
        // 좀전에 숫자를 누른 경우에는, setOperand 호출
        if userIsTypingDigit{
            brain.setOperand(value: displayText)
            userIsTypingDigit = false
        }
        // 숫자를 누르지 않아도 실행됨
        brain.performOperation(symbol: mathmeticalSymbol)
        displayText = brain.result
    }
    
}

