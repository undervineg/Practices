//
//  UnitModel.swift
//  UnitConverter
//
//  Created by 심 승민 on 2017. 10. 18..
//  Copyright © 2017년 심 승민. All rights reserved.
//

import Foundation

// 지원 단위 및 최소단위(cm,g,L) 기준 변환값.
private let lengthUnit: [String:Double] = ["cm" : 1, "m" : 100, "inch" : 2.54, "yard" : 91.44]
private let weightUnit: [String:Double] = ["g" : 1, "kg" : 1000, "lb" : 453.592, "oz" : 28.3495]
private let volumeUnit: [String:Double] = ["L" : 1, "pt" : 0.473176, "qt" : 0.946353, "gal" : 3.78541]
