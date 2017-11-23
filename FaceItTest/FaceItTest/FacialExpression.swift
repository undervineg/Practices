//
//  FacialExpression.swift
//  FaceItTest
//
//  Created by 심 승민 on 2017. 10. 9..
//  Copyright © 2017년 심 승민. All rights reserved.
//

import Foundation

struct FacialExpression{
    enum Eyes: Int{
        case Open
        case Closed
        case Squinting
    }
    
    enum EyeBrows: Int{
        case Relaxed
        case Normal
        case Furrowed
        
        func moreRelaxedBrow()->EyeBrows{
            return EyeBrows(rawValue: rawValue - 1) ?? .Relaxed
        }
        func moreFurrowedBrow()->EyeBrows{
            return EyeBrows(rawValue: rawValue + 1) ?? .Furrowed
        }
    }
    
    enum Mouth: Int{
        case Frown
        case Smirk
        case Neutral
        case Grin
        case Smile
        
        func sadderMouth()->Mouth{
            return Mouth(rawValue: rawValue - 1) ?? .Frown
        }
        func happierMouth()->Mouth{
            return Mouth(rawValue: rawValue + 1) ?? .Smile
        }
    }
    
    var eyes: Eyes
    var eyeBrows: EyeBrows
    var mouth: Mouth
}
