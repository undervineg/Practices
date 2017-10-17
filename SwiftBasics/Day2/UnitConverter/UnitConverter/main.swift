//
//  main.swift
//  UnitConverter
//
//  Created by 심 승민 on 2017. 10. 16..
//  Copyright © 2017년 심 승민. All rights reserved.
//

import Foundation
// 지원 단위 및 단위별 센티미터 기준 변환 값.
let lengthUnit: [String:Double] = ["cm" : 1, "m" : 100, "inch" : 2.54, "yard" : 91.44]

// 길이 구조체. 값 및 단위로 구성.
struct Length{
    var val: Double     // 길이값
    var unit: String    // 단위
    
    // 목표단위로 변환. returns 변환후 새 구조체 인스턴스.
    func convert(to newUnit: String?)->Length{
        // 현재 단위의 센티미터 기준 값.
        guard let selfUnitVal = lengthUnit[self.unit] else{ return Length(val:0, unit:"") }
        // 목표단위 nil인 경우.
        guard let destUnit = newUnit, let destUnitVal = lengthUnit[destUnit] else{
            // 미터로 변환. "m" 해당 값은 항상 있으므로, 강제 추출함.
            return Length(val: self.val * selfUnitVal / lengthUnit["m"]!, unit: "m")
        }
        // 목표단위 있는 경우. 현재길이를 센티미터로 변환. 목표단위의 센티미터 기준값으로 나누어 변환결과 계산. 새 Length 인스턴스 생성하여 반환.
        return Length(val: self.val * selfUnitVal / destUnitVal, unit: destUnit)
    }
    // returns 현재 길이값에 단위를 더한 문자열
    func toString()->String{
        return String(self.val) + unit
    }
}

// 입력한 길이, 단위를 목표단위로 변환. returns 새 단위를 붙인 변환 결과의 문자열.
func convertLength(_ currLengthWithUnit: String, to newUnit: String?) -> String {
    var currUnit: String = ""   // 현재 단위
    
    // 파라미터로 받은 문자열에서 단위부 탐색
    for (key, _) in lengthUnit {
        if currLengthWithUnit.hasSuffix(key){
            currUnit = key
            break   // 'cm'에서 'm'가 인식 되는 등 중복 탐색을 방지하기 위하여 첫 탐색 후 for문 나옴
        }
    }
    
    // 입력단위가 지원하는 단위인지 확인.
    if lengthUnit.keys.contains(currUnit) {
        // 숫자부와 단위부로 나누어 Length 타입으로 변환.
        // 숫자부 구할 시, 범위 연산자 대신 currLengthWithUnit.prefix(upto: currUnitIdexInLength) 써도 됨.
        if let firstCharOfCurrUnit = currUnit.first,
            let currUnitIndex = currLengthWithUnit.index(of: firstCharOfCurrUnit),
            let currDigitValue = Double(currLengthWithUnit[..<currUnitIndex]) {
            
            // 목표단위가 없는 경우.
            guard let destUnit = newUnit else{
                // 목표단위는 nil 전달.
                return Length(val: currDigitValue, unit: currUnit).convert(to: newUnit).toString()
            }
            // 목표단위가 있는 경우. 바꾸려는 단위가 지원하는 단위인지 확인.
            if lengthUnit.keys.contains(destUnit){
                // 입력값으로 Length 구조체를 생성. convert() 함수를 호출하여 단위 변환 후, toString() 함수로 변환결과값+목표단위를 String으로 리턴.
                return Length(val: currDigitValue, unit: currUnit).convert(to: destUnit).toString()
            }
        }
        
    }
    // 입력단위가 지원하는 단위가 아닌 경우, 안내 리턴.
    return "지원하지 않는 단위입니다."
}


// 사용자입력을 받아 결과출력. 종료 전까지 반복.
while(true){
    print("길이(단위포함)를 변환할 단위와 함께 입력해주세요:", terminator: " ")
    // 입력받은 문자열이 없는 경우 종료.
    guard let inputLine = readLine() else{ break }
    // q 또는 quit 입력 시 루프 종료.
    if inputLine == "q" || inputLine == "quit"{ break }
    // 공백 기준으로 입력값 자름. 현재 길이,단위와 목표단위로 나뉨.
    let separatedInput = inputLine.split(separator: " ")
    // 추가적인 공백 제거.
    let trimmedInput = separatedInput.map({$0.trimmingCharacters(in: .whitespaces)})
    // 결과 저장할 변수.
    var result: String = ""
    // 입력 값 개수에 따라 함수 파라미터 달라짐.
    if trimmedInput.count < 2{
        // 입력 값이 1개인 경우(예: 123yard), 목표단위는 nil로 전달.
        result = convertLength(trimmedInput[0], to: nil)
    }else{
        // 입력 값이 2개인 경우, 파라미터값 모두 전달.
        result = convertLength(trimmedInput[0], to: trimmedInput[1])
    }
    // 결과 출력.
    print(result)
}
