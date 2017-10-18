//
//  VendingMachine.swift
//  VendingMachinePackageDescription
//
//  Created by 심 승민 on 2017. 10. 11..
//

import Foundation

struct VendingMachine{
    private var balance: Int
    private var stocks: [Beverage]
    private var inventoryList: [[String:Int]]
    private var histories: [String]
    
    init(){
        balance = 0
        stocks = []
        inventoryList = []
        histories = []
    }
    
    // 사용자 지급액 추가
    mutating func insertMoney(amountOf amount: Int){
        balance += amount
    }
    
    // 재고 추가
    mutating func add(_ item: Menu, amountOf amount: Int){
        // 여러 개의 음료 생성
        for _ in 0..<amount{
            stocks.append( produce(item) )
        }
        inventoryList.append([item.name:getInventory(of: item) + amount])
    }
    
    private func getInventory(of item: Menu) -> Int{
        var count = 0
        for stock in stocks{
            if stock.name == item.name{
                count += 1
            }
        }
        return count
    }
    
    private func produce(_ item: Menu) -> Beverage{
        switch item {
        case .coke(size: .small):
            return Beverage(brand: "코카콜라 컴퍼니", weight: 250, price: item.price, name: item.name)
        case .coke(size: .medium):
            return Beverage(brand: "코카콜라 컴퍼니", weight: 250, price: item.price, name: item.name)
        case .vita500:
            return Beverage(brand: "광동제약", weight: 100, price: item.price, name: item.name)
        case .oronaminC:
            return Beverage(brand: "동아오츠카", weight: 120, price: item.price, name: item.name)
        case .perrier:
            return Beverage(brand: "네슬레", weight: 350, price: item.price, name: item.name)
        case .evian:
            return Beverage(brand: "다논", weight: 500, price: item.price, name: item.name)
        }
    }
    
    
    // balance 안에서 살 수 있는 음료 리스트 리턴. 음료자판기 버튼 빨갛게 표시하기 위함
    func getAffordableItemList() -> [String]{
        var affordableBeverages: [String] = []
        
        for item in Menu.menus{
            if isPriceAffordable(item){
                affordableBeverages.append(item.name)
            }
        }
        return affordableBeverages
    }
    
    
    // 사용자가 원하는 음료 이름을 받아 조건을 만족하면 음료 반환
    // 특정 음료의 가격이 사용자가 넣은 금액보다 같거나 작고, 특정음료가 품절이 아니면 구매 가능
    // 구매 시 재고에서 차감(-1), History 추가
    mutating func buy(_ item: Menu) -> Beverage?{
        if isPriceAffordable(item) && hasStocks(of: item){
            for (index,beverage) in stocks.enumerated(){
                if item.name == beverage.name{
                    let boughtItem = stocks.remove(at: index)
                    // 재고에서 해당 상품 1개 차감
                    
                    // 히스토리 추가
                    let history = boughtItem.toString() + " | purchase date: \(Date(timeIntervalSinceNow: 0.0))"
                    histories.append(history)
                    return boughtItem
                }
            }
        }
        return nil
    }
    
    private func isPriceAffordable(_ item: Menu) -> Bool{
        return (item.price <= balance) ? true : false
    }
    
    private func hasStocks(of item: Menu) -> Bool{
        for inventory in inventoryList{
            if let inventory = inventory[item.name] {
                return (inventory > 0) ? true : false
            }
        }
        return false
    }
    
    
    // 사용자가 입력한 금액에서 구매한 금액을 뺀 나머지 리턴
    mutating func checkBalance(item: Menu?)->Int{
        guard let selectedItem = item else { return balance }
        self.balance = balance - selectedItem.price
        return balance - selectedItem.price
    }
    
    // 현재 남아있는 음료의 재고 리스트(음료명:재고수) 리턴. 품절 표시하기 위함.
    func getInventoryList() -> [[String:Int]]{
        return inventoryList
    }
    
    // 이제까지 쌓아온 History 배열 반환
    func getPurchaseHistory() -> [String]{
        return histories
    }
}

