//
//  main.swift
//  UnitConverter
//
//  Created by 심 승민 on 2017. 10. 16..
//  Copyright © 2017년 심 승민. All rights reserved.
//

import Foundation

// 단위 변환기
func lengthConverter(inputLength: String)->String{
    let divider: Double = 100.0
    var result: String = ""
    var inputLength = inputLength
    var inputDouble: Double{ return Double(inputLength)! }
    
    func centimeterToMeter(inputNumber: Double)->Double{
        return Double(inputNumber / divider)
    }
    
    func meterToCentimeter(inputNumber: Double)->Double{
        return Double(inputNumber * divider)
    }
    
    if inputLength.contains("cm"){
        for _ in 0..<2{
            inputLength.removeLast()
        }
        result = String(centimeterToMeter(inputNumber: inputDouble))+"m"
    }
    else if inputLength.contains("m"){
        inputLength.removeLast()
        result = String(meterToCentimeter(inputNumber: inputDouble))+"cm"
    }
    else{
        result = "none"
    }
    
    return result
}


// 사용자 입력을 받아 결과 출력
while(true){
    print("길이를 단위(cm 또는 m)와 함께 입력해주세요:", terminator: " ")
    if let inputLine = readLine(){
        print( lengthConverter(inputLength: inputLine) )
    }
}
