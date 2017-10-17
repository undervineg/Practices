//
//  main.swift
//  UnitConverter
//
//  Created by 심 승민 on 2017. 10. 16..
//  Copyright © 2017년 심 승민. All rights reserved.
//

import Foundation

let lengthUnit: [String:Double] = ["cm" : 1, "m" : 100, "inch" : 2.54]

// 길이를 표현하는 구조체로, 값과 단위로 이루어져 있다.
struct Length{
    var val: Double
    var unit: String
    // 파라미터로 넘겨받은 단위로 변환하는 함수
    func convert(to unit: String)->Length{
        // 현재 val 값을 cm 기준으로 변환한 후 바꿀 unit 값으로 나눈 값을 새 Length를 만들어 반환
        guard let selfUnit = lengthUnit[self.unit], let toUnit = lengthUnit[unit] else{ return Length(val: 0, unit: "") }
        return Length(val: self.val * selfUnit / toUnit, unit: unit)
    }
    func toString()->String{
        return String(self.val) + unit
    }
}

// 단위 변환기
func convertLength(_ length: String, to unit: String) -> String {
    var currUnit: String = ""
    
    // 파라미터로 받은 문자열에서 단위부 탐색
    for (key, _) in lengthUnit {
        if length.hasSuffix(key){
            currUnit = key
            break   // 'cm'에서 'm'가 인식 되는 등 중복 탐색을 방지하기 위하여 첫 탐색 후 for문 나옴
        }
    }
    // 입력한 단위들이 지원하는 단위인지 확인
    if lengthUnit.keys.contains(currUnit) && lengthUnit.keys.contains(unit){
        // 숫자부와 단위부로 나누어 Length 타입으로 변환
        // index(of)로 구한 index는 옵셔널 타입이기 때문에 범위연산자에 넣을 때 언래핑해야 함!
        if let firstIndexOfcurrUnit = currUnit.first,
            let currUnitIndexInLength = length.index(of: firstIndexOfcurrUnit),
            let currDigitDouble = Double(length[..<currUnitIndexInLength]) {
            // Length 타입의 convert() 함수를 호출하여 단위 변환
            return Length(val: currDigitDouble, unit: currUnit).convert(to: unit).toString()
        }
    }
    return "지원하지 않는 단위입니다."
}


// 사용자 입력을 받아 결과 출력
while(true){
    print("길이(단위포함)를 변환할 단위와 함께 입력해주세요:", terminator: " ")
    if let inputLine = readLine(){
        let separatedInput = inputLine.split(separator: " ")
        let trimmedInput = separatedInput.map({$0.trimmingCharacters(in: .whitespaces)})
        let result = convertLength(trimmedInput[0], to: trimmedInput[1])
        print(result)
    }
}
