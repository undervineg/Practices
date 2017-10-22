//
//  main.swift
//  UnitConverter
//
//  Created by 심 승민 on 2017. 10. 16..
//  Copyright © 2017년 심 승민. All rights reserved.
//

import Foundation

// 지원 단위 및 최소단위(cm,g,L) 기준 변환값.
// static을 쓸 수 없는 이유는 전역변수이기 때문인가? 추후 따로 다른 파일에 옮겨서 사용.
let lengthUnit: [String:Double] = ["cm": 1, "m": 100, "km": 100000, "inch": 2.54, "ft": 30.48, "yard": 91.44, "mile": 160934.4]
let weightUnit: [String:Double] = ["g": 1, "kg": 1000, "lb": 453.592, "oz": 28.3495]
let volumeUnit: [String:Double] = ["L": 1, "pt": 0.473176, "qt": 0.946353, "gal": 3.78541]
// 결과값에서 경고('지원되지 않는 단위입니다.')를 구분하기 위한 문자.
let warningEscape: String = "!"

// 단위 프로토콜
protocol UnitConvertible {
    var val: Double { get set }
    var unit: String { get set }
    func convert(to newUnit: String?)->Any
    func convertToAll()->[Any]
    func toString()->(String, String)
}

// 부피 구조체
struct Volume: UnitConvertible {
    var val: Double
    var unit: String
    
    func convert(to newUnit: String?)->Any{
        guard let selfUnitVal = volumeUnit[self.unit] else{ return Volume(val:0, unit:"") }
        guard let destUnit = newUnit, let destUnitVal = volumeUnit[destUnit] else{
            // 목표단위가 없으면 'pt'로 변환
            return Volume(val: self.val * selfUnitVal / volumeUnit["pt"]!, unit: "pt")
        }
        return Volume(val: self.val * selfUnitVal / destUnitVal, unit: destUnit)
    }
    
    func convertToAll()->[Any]{
        var resultUnits: [Volume] = []
        guard let selfUnitVal = volumeUnit[self.unit] else { return resultUnits }
        for (destUnitKey, destUnitVal) in volumeUnit where destUnitKey != self.unit{
            let newLength: Volume = Volume(val: self.val * selfUnitVal / destUnitVal, unit: destUnitKey)
            resultUnits.append(newLength)
        }
        return resultUnits
    }
    
    func toString()->(String,String){
        return (String(self.val), unit)
    }
}

// 무게 구조체
struct Weight: UnitConvertible {
    var val: Double
    var unit: String
    
    func convert(to newUnit: String?)->Any{
        guard let selfUnitVal = weightUnit[self.unit] else{ return Weight(val:0, unit:"") }
        guard let destUnit = newUnit, let destUnitVal = weightUnit[destUnit] else{
            // 목표단위가 없으면 'kg'으로 변환
            return Weight(val: self.val * selfUnitVal / weightUnit["kg"]!, unit: "kg")
        }
        return Weight(val: self.val * selfUnitVal / destUnitVal, unit: destUnit)
    }
    
    func convertToAll()->[Any]{
        var resultUnits: [Weight] = []
        guard let selfUnitVal = weightUnit[self.unit] else { return resultUnits }
        for (destUnitKey, destUnitVal) in weightUnit where destUnitKey != self.unit{
            let newLength: Weight = Weight(val: self.val * selfUnitVal / destUnitVal, unit: destUnitKey)
            resultUnits.append(newLength)
        }
        return resultUnits
    }
    
    func toString()->(String,String){
        return (String(self.val), unit)
    }
}

// 길이 구조체
struct Length: UnitConvertible{
    var val: Double     // 길이값
    var unit: String    // 단위
    
    // 목표단위로 변환. returns 변환 후 새 구조체 인스턴스.
    func convert(to newUnit: String?)->Any{
        // 현재 단위의 센티미터 기준 값.
        guard let selfUnitVal = lengthUnit[self.unit] else { return Length(val:0, unit:"") }
        guard let destUnit = newUnit, let destUnitVal = lengthUnit[destUnit] else{
            // 목표단위가 없으면 'm'로 변환. "m" 해당 값은 항상 있으므로, 강제 추출함.
            return Length(val: self.val * selfUnitVal / lengthUnit["m"]!, unit: "m")
        }
        // 목표단위 있는 경우. 현재길이를 센티미터로 변환. 목표단위의 센티미터 기준값으로 나누어 변환결과 계산. 새 Length 인스턴스 생성하여 반환.
        return Length(val: self.val * selfUnitVal / destUnitVal, unit: destUnit)
    }
    
    // 현재단위를 제외한 모든 단위로 변환. returns 변환 후 새 구조체 인스턴스 배열.
    func convertToAll()->[Any]{
        var resultUnits: [Length] = []
        guard let selfUnitVal = lengthUnit[self.unit] else { return resultUnits }
        
        // 길이의 모든 단위를 돌면서 Length 구조체 생성.
        for (destUnitKey, destUnitVal) in lengthUnit where destUnitKey != self.unit{
            // 현재단위와 같은 경우 스킵하고 계속 진행. - where 또는 continue 사용 가능.
            //if destUnitKey == self.unit{ continue }
            let newLength: Length = Length(val: self.val * selfUnitVal / destUnitVal, unit: destUnitKey)
            // 생성한 Length 구조체를 배열에 추가.
            resultUnits.append(newLength)
        }
        return resultUnits
    }
    
    // returns 숫자부와 단위부의 튜플. 화면 표시 시 단위부만 강조해서 사용하기 위함
    func toString()->(String,String){
        return (String(self.val), unit)
    }
}

// 단위부 검색. 단위가 길이인지, 무게인지, 부피인지도 판별.
func searchUnitPart(from currValue: String)->(UnitConvertible.Type, String){
    for key in lengthUnit.keys{
        // 해당되는 단위가 있으면 바로 리턴하여 for문 및 함수 탈출.
        if currValue.hasSuffix(key){ return (Length.self, key) }
    }
    for key in weightUnit.keys{
        if currValue.hasSuffix(key){ return (Weight.self, key) }
    }
    for key in volumeUnit.keys{
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

// returns 입력단위를 목표단위로 변환한 결과값을 숫자부, 단위부로 나누어 문자열 튜플로 반환.
func getNew(_ unitType: UnitConvertible.Type, from currVal: Double, of currUnit: String, to destUnit: String?)->(String, String){
    // 타입이름으로 매칭시킴.
    let typeName: String = String(describing: unitType)
    switch typeName {
    case "Length": return (Length(val: currVal, unit: currUnit).convert(to: destUnit) as! Length).toString()
    case "Weight": return (Weight(val: currVal, unit: currUnit).convert(to: destUnit) as! Weight).toString()
    case "Volume": return (Volume(val: currVal, unit: currUnit).convert(to: destUnit) as! Volume).toString()
    default: return ("","")
    }
}

// 모든 단위로 변환한 결과 반환.
func getAllNew(_ unitType: UnitConvertible.Type, from currVal: Double, of currUnit: String)->[(String, String)]{
    let typeName: String = String(describing: unitType)
    var results: [Any] = []
    var resultStrings: [(String, String)] = []
    // 타입이름으로 매칭시킴. 배열 받아옴.
    switch typeName {
    case "Length":
        results = Length(val: currVal, unit: currUnit).convertToAll() as! [Length]
        // 각각의 값을 문자열로 변환하여 다시 배열로 만듦.
        for result in results{
            resultStrings.append((result as! Length).toString())
        }
    case "Weight":
        results = Weight(val: currVal, unit: currUnit).convertToAll() as! [Weight]
        for result in results{
            resultStrings.append((result as! Weight).toString())
        }
    case "Volume":
        results = Volume(val: currVal, unit: currUnit).convertToAll() as! [Volume]
        for result in results{
            resultStrings.append((result as! Volume).toString())
        }
    default: return resultStrings
    }
    
    // 결과 문자열 배열 반환.
    return resultStrings
}


// [메인1] 사용자 입력값을 숫자부, 단위부로 나누어 목표단위로 변환. returns 변환결과의 숫자부, 단위부 튜플.
func convertUnit(from currValueWithUnit: String, to newUnit: String?)->(String, String){
    var result: (String, String) = ("","")                                          // 결과값의 숫자부, 단위부 저장 튜플.
    
    // 파라미터로 받은 문자열에서 단위부 탐색.
    let (unitType, currUnit) = searchUnitPart(from: currValueWithUnit)    // 현재 단위 저장 변수. 단위 타입도 저장(Length,Weight,Volume)
    let unitModel: [String:Double] = getUnitModel(of: unitType)           // 해당되는 단위 모델이 저장될 변수.
    
    // 단위부가 지원되는 값인지 확인.
    if isUnitAvailable(currUnit, unitModel){
        // 파라미터로 받은 문자열에서 숫자부 탐색.
        guard let currDigitValue = searchDigitPart(from: currValueWithUnit, without: currUnit) else {
            return ("지원되지 않는 단위입니다", warningEscape)
        }
        
        // 한 개씩 변환할 때. 목표단위의 유무로 나눔.
        if let destUnit = newUnit{
            // 목표단위가 있는 경우. 목표단위가 지원되는 값인지 확인.
            if isUnitAvailable(destUnit, unitModel){
                // 목표단위로 변환한 결과값을 문자열로 받아 저장.
                result = getNew(unitType, from: currDigitValue, of: currUnit, to: destUnit)
            }else{
                result = ("지원되지 않는 단위입니다", warningEscape)
            }
        }else{
            // 목표단위가 없는 경우. 목표단위는 nil이 전달됨.
            result = getNew(unitType, from: currDigitValue, of: currUnit, to: newUnit)
        }
        return result
    }
    
    // 단위부가 지원되지 않는 경우, 경고 메시지 반환.
    return ("지원되지 않는 단위입니다", warningEscape)
}

// [메인2] 사용자 입력값을 숫자부, 단위부로 나누어 모든 단위로 변환. returns 변환결과의 숫자부, 단위부 튜플 배열.
func convertToAllUnit(from currValueWithUnit: String)->[(String, String)]{
    var result: [(String, String)] = []
    // 파라미터로 받은 문자열에서 단위타입 및 단위부 탐색. 이를 통해 해당되는 단위 데이터 받아옴.
    let (unitType, currUnit) = searchUnitPart(from: currValueWithUnit)
    let unitModel: [String:Double] = getUnitModel(of: unitType)
    
    // 단위부가 지원되는 값이면
    if isUnitAvailable(currUnit, unitModel){
        // 숫자부 탐색.
        if let currDigitValue = searchDigitPart(from: currValueWithUnit, without: currUnit){
            // 입력값을 변환한 결과값들을 모두 가져옴.(문자열 배열)
            result = getAllNew(unitType, from: currDigitValue, of: currUnit)
        }
    }else{
        result = [("지원되지 않는 단위입니다",warningEscape)]
    }
    return result
}

// 사용자 입력 값을 slice 하여 메인함수 실행. 1개의 변환결과만 출력.
func execute(_ inputLine: String){
    // 결과값 저장 튜플. 숫자부, 문자부로 구성.
    var convertResult: (String, String) = ("", "")
    // 공백 기준으로 입력값 자름. 현재 길이,단위와 목표단위로 나뉨.
    let separatedInput = inputLine.split(separator: " ")
    // 추가적인 공백 제거.
    let trimmedInput = separatedInput.map({$0.trimmingCharacters(in: .whitespaces)})
    // 입력 값 개수에 따라 함수 파라미터 달라짐.
    if trimmedInput.count < 2{
        // 입력 값이 1개인 경우(예: 123yard), 목표단위는 nil로 전달.
        convertResult = convertUnit(from: trimmedInput[0], to: nil)
    }else{
        // 입력 값이 2개인 경우, 목표단위까지 모두 전달.
        convertResult = convertUnit(from: trimmedInput[0], to: trimmedInput[1])
    }
    // 숫자부와 단위부 색상 나눔.
    var afterConvert: String = ""
    if convertResult.1 == warningEscape{
        // 지원되지 않는 단위인 경우, 빨간색 표시.
        afterConvert = "\(ANSICode.text.redBright) ✖︎ \(convertResult.0) ✖︎"
    }else{
        afterConvert = "\(ANSICode.text.blue) \(convertResult.0) \(ANSICode.text.magentaBright)\(convertResult.1)"
    }
    // "변환결과:" 텍스트 우측에 결과값 출력.
    print("\(ANSICode.cursor.move(row: 2, col: 40))\(ANSICode.eraseEndLine)\(afterConvert)")
}

// 사용자 입력 값으로 메인함수 실행. 모든 변환결과 출력.
func executeAll(_ inputLine: String){
    let separatedInput = inputLine.split(separator: " ")
    let trimmedInput = separatedInput.map({$0.trimmingCharacters(in: .whitespaces)})
    let convertResults: [(String, String)] = convertToAllUnit(from: trimmedInput[0])    // 단위변환 함수 호출결과 저장.
    var currRow: Int = 4
    var currCol: Int = 30
    let maxRowPerEachCol: Int = 5
    
    for (index, result) in convertResults.enumerated(){                                 // 단위 출력순서는 뒤죽박죽임.. 딕셔너리를 썼기 때문.
        // 한 줄(컬럼)당 최대 개수를 넘으면
        if index/maxRowPerEachCol > 0 && index%maxRowPerEachCol == 0{
            currCol += 25    // 옆 줄로 옮김(col).
            currRow = 4
        }
        // 결과값 출력 위치. 숫자부와 단위부 색상 나눔. 이전출력은 지움.
        print("\(ANSICode.cursor.move(row: currRow, col: currCol))\(ANSICode.eraseEndLine)\(ANSICode.text.blue) \(result.0) \(ANSICode.text.magenta)\(result.1)")
        currRow += 2        // 두 행(row) 내려감.
    }
}


print("\(ANSICode.clear)\(ANSICode.home)")
// 변환가능한 단위리스트 출력 영역.
print("\(ANSICode.rect.draw(origin: (1,1), size: (26, 13), isFill: false))")
print("\(ANSICode.cursor.move(row: 2, col: 3))\(ANSICode.text.blackBright)변환가능한 단위리스트")
print("\(ANSICode.cursor.move(row: 4, col: 4))\(ANSICode.text.cyan)길이단위")
print("\(ANSICode.cursor.move(row: 5, col: 4))\(ANSICode.text.cyan)cm | m | km | inch |")
print("\(ANSICode.cursor.move(row: 6, col: 4))\(ANSICode.text.cyan)ft | yard | mile")
/* 데이터 키값을 그대로 출력. --> 위치 잡기가 힘듦.
 print("\(ANSICode.cursor.move(row: 4, col: 0))")
 for (index, unit) in lengthUnit.keys.enumerated(){
 if index%4 == 0 && index/4 > 0{
 print("")
 }
 print("\(ANSICode.text.cyan)\(unit) |", terminator: " ")
 }
 */
print("\(ANSICode.cursor.move(row: 8, col: 4))\(ANSICode.text.yellow)무게단위")
print("\(ANSICode.cursor.move(row: 9, col: 4))\(ANSICode.text.yellow)g | kg | lb | oz")
print("\(ANSICode.cursor.move(row: 11, col: 4))\(ANSICode.text.magenta)부피단위")
print("\(ANSICode.cursor.move(row: 12, col: 4))\(ANSICode.text.magenta)L | pt | qt | gal")
// 변환결과 출력 영역.
print("\(ANSICode.text.green)\(ANSICode.rect.draw(origin: (28,1), size: (55, 13), isFill: false))")
print("\(ANSICode.cursor.move(row: 2, col: 30))\(ANSICode.text.blackBright)변환결과: ")
// 종료 안내문구 위치.
print("\(ANSICode.cursor.move(row: 15, col: 62))\(ANSICode.text.red)* 종료: quit(or q)")


// 사용자입력을 받아 결과출력. 종료 전까지 반복.
while(true){
    // 2번 이상 실행 시, 이전입력값은 지움.
    print("\(ANSICode.cursor.move(row: 16, col: 1))\(ANSICode.eraseEndLine)\(ANSICode.text.black) > 현재길이와 단위를 목표단위와 함께 입력해주세요:", terminator: " ")
    // 입력받은 문자열이 없는 경우 종료.
    guard let inputLine = readLine() else{ break }
    // q 또는 quit 입력 시 루프 종료.
    if inputLine == "q" || inputLine == "quit"{ break }
    // 단위변환 실행.
    execute(inputLine)      // 목표단위로 변환
    executeAll(inputLine)   // 모든 단위로 변환
    // 이전출력을 지우면서 사각형의 일부가 지워졌으므로 다시 그림.
    print("\(ANSICode.text.green)\(ANSICode.rect.draw(origin: (28,1), size: (55, 13), isFill: false))")
}


