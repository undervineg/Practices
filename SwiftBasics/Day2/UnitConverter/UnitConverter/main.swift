//
//  main.swift
//  UnitConverter
//
//  Created by 심 승민 on 2017. 10. 16..
//  Copyright © 2017년 심 승민. All rights reserved.
//

import Foundation

// 지원 단위 및 최소단위(cm,g,L) 기준 변환값.
// static을 쓸 수 없는 이유는 전역변수이기 때문인가?
let lengthUnit: [String:Double] = ["cm" : 1, "m" : 100, "inch" : 2.54, "yard" : 91.44]
let weightUnit: [String:Double] = ["g" : 1, "kg" : 1000, "lb" : 453.592, "oz" : 28.3495]
let volumeUnit: [String:Double] = ["L" : 1, "pt" : 0.473176, "qt" : 0.946353, "gal" : 3.78541]

// 단위 프로토콜
protocol UnitConvertible {
    var val: Double { get set }
    var unit: String { get set }
    func convert(to newUnit: String?)->Any
    func toString()->String
}

// 부피 구조체
struct Volume: UnitConvertible {
    var val: Double
    var unit: String
    
    func convert(to newUnit: String?)->Any{
        guard let selfUnitVal = volumeUnit[self.unit] else{ return Volume(val:0, unit:"") }
        guard let destUnit = newUnit, let destUnitVal = volumeUnit[destUnit] else{
            return Volume(val: self.val * selfUnitVal / volumeUnit["m"]!, unit: "m")
        }
        return Volume(val: self.val * selfUnitVal / destUnitVal, unit: destUnit)
    }
    
    func toString()->String{
        return String(self.val) + unit
    }
}

// 무게 구조체
struct Weight: UnitConvertible {
    var val: Double
    var unit: String
    
    func convert(to newUnit: String?)->Any{
        guard let selfUnitVal = weightUnit[self.unit] else{ return Weight(val:0, unit:"") }
        guard let destUnit = newUnit, let destUnitVal = weightUnit[destUnit] else{
            return Weight(val: self.val * selfUnitVal / weightUnit["m"]!, unit: "m")
        }
        return Weight(val: self.val * selfUnitVal / destUnitVal, unit: destUnit)
    }
    
    func toString()->String{
        return String(self.val) + unit
    }
}

// 길이 구조체
struct Length: UnitConvertible{
    var val: Double     // 길이값
    var unit: String    // 단위
    
    // 목표단위로 변환. returns 변환후 새 구조체 인스턴스.
    func convert(to newUnit: String?)->Any{
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

// 단위부 검색. 단위가 길이인지, 무게인지, 부피인지도 판별.
func searchUnitPart(from currValue: String)->(UnitConvertible.Type, String){
    for key in lengthUnit.keys{
        // 'cm'에서 'm'가 인식 되는 등 중복 탐색을 방지하기 위하여 첫 탐색 후 for문 나옴.
        if currValue.hasSuffix(key){ return (Length.self, key) }
    }
    for key in weightUnit.keys{
        // 'cm'에서 'm'가 인식 되는 등 중복 탐색을 방지하기 위하여 첫 탐색 후 for문 나옴.
        if currValue.hasSuffix(key){ return (Weight.self, key) }
    }
    for key in volumeUnit.keys{
        // 'cm'에서 'm'가 인식 되는 등 중복 탐색을 방지하기 위하여 첫 탐색 후 for문 나옴.
        if currValue.hasSuffix(key){ return (Volume.self, key) }
    }
    return (Length.self, "cm")
}

// 숫자부 검색.
func searchDigitPart(from currValue: String, without currUnit: String)->Double?{
    // 숫자부 구할 시, 범위 연산자 대신 currLengthWithUnit.prefix(upto: currUnitIdexInLength) 써도 됨.
    if  let firstCharOfCurrUnit = currUnit.first,
        let currUnitIndex = currValue.index(of: firstCharOfCurrUnit),
        let currDigitValue = Double(currValue[..<currUnitIndex]) {
        return currDigitValue
    }else{
        return nil
    }
}

// returns 입력단위에 해당하는 데이터모델. 길이 또는 무게 또는 부피 등.
func getUnitModel(of type: UnitConvertible.Type)->[String:Double]{
    var unitModel: [String:Double] = [:]
    let typeName: String = String(describing: type)     // 타입 이름을 문자열로 변환.
    
    switch typeName {
    case "Length": unitModel = lengthUnit
    case "Weight": unitModel = weightUnit
    case "Volume": unitModel = volumeUnit
    default: break
    }
    return unitModel
}

// 단위부가 지원되는 값인지 확인하는 함수. returns Bool.
func isUnitAvailable(_ currUnit: String, _ unitModel: [String:Double])->Bool{
    if unitModel.keys.contains(currUnit) { return true }
    else { return false }
}

// returns 입력단위를 목표단위로 변환한 문자열.
func getNew(_ unitType: UnitConvertible.Type, from currVal: Double, of currUnit: String, to destUnit: String?)->String{
    let typeName: String = String(describing: unitType)
    // 타입의 문자열 이름으로 매칭.
    switch typeName {
    case "Length": return (Length(val: currVal, unit: currUnit).convert(to: destUnit) as! Length).toString()
    case "Weight": return (Weight(val: currVal, unit: currUnit).convert(to: destUnit) as! Weight).toString()
    case "Volume": return (Volume(val: currVal, unit: currUnit).convert(to: destUnit) as! Volume).toString()
    default: return ""
    }
}

// 단위 변환 메인함수.
func convertUnit(from currValueWithUnit: String, to newUnit: String?)->String{
    var result: String = ""                                               // 결과값 저장 변수.
    
    // 파라미터로 받은 문자열에서 단위부 탐색.
    let (unitType, currUnit) = searchUnitPart(from: currValueWithUnit)    // 현재 단위 저장 변수.
    let unitModel: [String:Double] = getUnitModel(of: unitType)           // 해당되는 단위 모델이 저장될 변수.

    // 단위부가 지원되는 값인지 확인.
    if isUnitAvailable(currUnit, unitModel){
        // 파라미터로 받은 문자열에서 숫자부 탐색.
        guard let currDigitValue = searchDigitPart(from: currValueWithUnit, without: currUnit) else {
            return "지원하지 않는 단위입니다."
        }
        
        // 목표단위가 있는 경우. 바꾸려는 단위가 지원하는 단위인지 확인.
        if let destUnit = newUnit{
            // 목표단위가 지원되는 값인지 확인.
            if isUnitAvailable(destUnit, unitModel){
                // 입력값으로 해당 단위의 구조체를 생성.
                // convert() 함수를 호출하여 단위 변환 후, toString() 함수로 변환결과값+목표단위를 String으로 리턴.
                result = getNew(unitType, from: currDigitValue, of: currUnit, to: destUnit)
            }
        }else{
            // 목표단위가 없는 경우. 목표단위는 nil이 전달됨.
            result = getNew(unitType, from: currDigitValue, of: currUnit, to: newUnit)
        }
        return result
    }
    
    return "지원되지 않는 단위입니다."
}

// 사용자 입력 값을 slice 하여 단위변환 함수 호출. returns 목표단위값 문자열.
func execute(inputLine: String)->String{
    // 결과값 저장 변수.
    var result: String = ""
    // 공백 기준으로 입력값 자름. 현재 길이,단위와 목표단위로 나뉨.
    let separatedInput = inputLine.split(separator: " ")
    // 추가적인 공백 제거.
    let trimmedInput = separatedInput.map({$0.trimmingCharacters(in: .whitespaces)})
    // 입력 값 개수에 따라 함수 파라미터 달라짐.
    if trimmedInput.count < 2{
        // 입력 값이 1개인 경우(예: 123yard), 목표단위는 nil로 전달.
        result = convertUnit(from: trimmedInput[0], to: nil)
    }else{
        // 입력 값이 2개인 경우, 목표단위까지 모두 전달.
        result = convertUnit(from: trimmedInput[0], to: trimmedInput[1])
    }
    return result
}

// 사용자입력을 받아 결과출력. 종료 전까지 반복.
while(true){
    print("길이(단위포함)를 변환할 단위와 함께 입력해주세요:", terminator: " ")
    // 입력받은 문자열이 없는 경우 종료.
    guard let inputLine = readLine() else{ break }
    // q 또는 quit 입력 시 루프 종료.
    if inputLine == "q" || inputLine == "quit"{ break }
    // 결과 출력.
    print(execute(inputLine: inputLine))
}
