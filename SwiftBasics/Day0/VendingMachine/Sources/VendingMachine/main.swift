import Foundation


// Vending Machine 생성
var machine = VendingMachine()
// 재고 넣기
machine.add(Menu.coke(size: Menu.Size.small), amountOf: 1)
machine.add(Menu.coke(size: Menu.Size.medium), amountOf: 10)
machine.add(Menu.evian, amountOf: 10)
machine.add(Menu.oronaminC, amountOf: 10)
machine.add(Menu.perrier, amountOf: 10)
machine.add(Menu.vita500, amountOf: 10)
print("자판기에 재고가 추가되었습니다.")

print("=========상품리스트=========")
var inventoryList = machine.getInventoryList()
for inventory in inventoryList{
    for (key, val) in inventory{
        if val <= 0{
            print("\(ANSICode.text.blue)\(key): \(ANSICode.text.red)품절")
        }else{
            print("\(ANSICode.text.blue)\(key)")
        }
    }
}

// 메뉴 구성 - 단축키 : 메뉴이름
// 키보드로 입력 받음
print("메뉴[번호]를 입력해주세요.")
print("메뉴[1]: 현금 넣기")
print("메뉴[2]: 상품 선택")
print("메뉴[3]: 잔액 보기")
print("메뉴[4]: 상품 보기")
print("메뉴[5]: 구입내역 보기")
print("종료: quit(or q)")

while(true){
    guard let line = readLine() else { break }
    
    switch line{
    case "1":
        print("메뉴[1]: 현금을 넣어주세요:")
        while(true){
            guard let moneyInput = readLine() else{ print("다시 입력해주세요."); break}
            if let coinAmount = Int(moneyInput){
                // 현금 투입
                machine.insertMoney(amountOf: coinAmount)
                // 누적 금액 확인
                print("누적 금액: \(machine.checkBalance(item: nil))원")
                // 구입 가능한 상품 보여주기
                print(machine.getAffordableItemList())
            }
            if moneyInput == "b" || moneyInput == "back"{ break }
        }
    case "2":
        print("메뉴[2]: 상품 선택")
        for (index, menu) in Menu.menus.enumerated(){
            print("메뉴 번호를 골라주세요.")
            print("[\(index)] \(menu.name)")
        }
        while(true){
            guard let inputString = readLine() else { break }
            guard let selectedItemIndex = Int(inputString) else { print("다시 입력해주세요."); break }
            let menuItem = Menu.menus[selectedItemIndex]
            let balance = machine.checkBalance(item: menuItem)
            if balance >= 0{
                guard let boughtItem = machine.buy(menuItem) else { break }
                print("방금 산 물건:", boughtItem.name)
                print(machine.getPurchaseHistory())
            }else{
                print("잔액이 부족합니다."); break
            }
            if inputString == "b" || inputString == "back"{ break }
        }
    case "3":
        print("메뉴[3]: 잔액 보기")
        print(machine.checkBalance(item: nil), "원")
    case "4":
        print("메뉴[4]: 상품 보기")
        let inventoryList = machine.getInventoryList()
        for inventory in inventoryList{
            for (key, val) in inventory{
                if val <= 0{
                    print("\(ANSICode.text.blue)\(key): \(ANSICode.text.red)품절")
                }else{
                    print("\(ANSICode.text.blue)\(key)")
                }
            }
        }
    case "5":
        print("메뉴[5]: 구입내역 보기")
        print(machine.getPurchaseHistory())
        break
    default: break
    }
    // 다시 메뉴로
    print("\n메뉴[번호]를 입력해주세요.")
    print("메뉴[1]: 현금 넣기")
    print("메뉴[2]: 상품 선택")
    print("메뉴[3]: 잔액 보기")
    print("메뉴[4]: 상품 보기")
    print("메뉴[5]: 구입내역 보기")
    print("종료: quit(or q)")
    
    if line == "q" || line == "quit"{ break }
}


