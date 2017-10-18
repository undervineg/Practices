//
//  main.swift
//  HelloSwift
//
//  Created by JK on 03/08/2017.
//  Copyright © 2017 JK. All rights reserved.
//

import Foundation

print("\(ANSICode.clear)\(ANSICode.home)")
print("\(ANSICode.text.whiteBright)\(ANSICode.rect.draw(origin:(1,1), size:(102,30), isFill:false))")
print("\(ANSICode.bgText.blueBright)\(ANSICode.rect.draw(origin:(10,10), size:(10,5), isFill:true))")
print("\(ANSICode.none)\(ANSICode.cursor.move(row: 2, col: 2))\(ANSICode.text.colorFrom(R: 250, G: 128, B: 32))배달의민족")
print("\(ANSICode.cursor.move(row:5, col:5))\(ANSICode.text.green)WOOWA")
print("\(ANSICode.cursor.move(row: 11, col: 11))\(ANSICode.text.yellow)BRO.\(ANSICode.none).")
print("\(ANSICode.cursor.move(row:32, col:1))종료: quit(or q)")

while(true) {
    let readString = readLine()
    if (readString == "q") || (readString == "quit") {
        break
    }
    
}
