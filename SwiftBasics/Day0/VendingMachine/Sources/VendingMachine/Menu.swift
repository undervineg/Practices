//
//  Menu.swift
//  VendingMachinePackageDescription
//
//  Created by 심 승민 on 2017. 10. 11..
//

import Foundation

enum Menu {
    enum Size{
        case small, medium
    }
    case coke(size: Size)
    case vita500
    case oronaminC
    case perrier
    case evian
    
    func getMenu(name: String)->Menu?{
        if self.name == name{
            switch self {
            case .coke(size: Size.small): return self
            case .coke(size: Size.medium): return self
            case .vita500: return self
            case .oronaminC: return self
            case .perrier: return self
            case .evian: return self
            }
        }
        return nil
    }
    
    var price: Int{
        switch self {
        case .coke(size: Size.small): return 700
        case .coke(size: Size.medium): return 1500
        case .vita500: return 500
        case .oronaminC: return 1000
        case .perrier: return 3000
        case .evian: return 1500
        }
    }
    
    var name: String{
        switch self {
        case .coke(size: Size.small): return "코카콜라 250ml"
        case .coke(size: Size.medium): return "코카콜라 500ml"
        case .vita500: return "비타500"
        case .oronaminC: return "오로나민씨"
        case .perrier: return "페리에"
        case .evian: return "에비앙"
        }
    }
    
    static let menus: [Menu] = [.coke(size: .small), .coke(size: .medium), .evian, .vita500, .oronaminC, .perrier]
    
}


