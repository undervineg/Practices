//
//  main.swift
//  UnitConverter
//
//  Created by 심 승민 on 2017. 10. 16..
//  Copyright © 2017년 심 승민. All rights reserved.
//

import Foundation

// 단위 변환기
func lengthConverter(inputLength: String) -> String{
    let divider: Int = 100
    var doubleDivider: Double { return Double(divider) }
    var result: String = ""
    var inputLength = inputLength
    
    if inputLength.contains("cm"){
        for _ in 0..<2{
            inputLength.removeLast()
        }
        if let inputLength = Double(inputLength){
            result = String(inputLength / doubleDivider)
        }
        result += "m"
    }else if inputLength.contains("m"){
        inputLength.removeLast()
        if let inputLength = Double(inputLength){
            result = String(inputLength * doubleDivider)
        }
        result += "cm"
    }else{
        result = "none"
    }
    
    return result
}

print(lengthConverter(inputLength: "120cm"))
print(lengthConverter(inputLength: "1.86m"))

