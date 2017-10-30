## 클로저
- **순수한 함수** : 외부 변수에 영향을 받지 않는 함수, 결과가 예측되는 함수.
- 클로저는 순수하게 만들기 위해 외부변수가 함수 안에 있으면 특정 시점의 외부변수의 값을 캡쳐하고 닫아버리도록 설계됨.
- swift는 값이 아닌 **변수를 캡쳐**하여 참조.
- **값을 캡쳐하는 방법** : **\[변수명]\[변수명]** (파라미터) in … 이런 식으로 [변수명]으로 캡쳐목록을 작성하면 변수의 값만 캡쳐.
- **캡쳐 시점**: **컴파일러가 해석하는 시점**으로 생각하면 됨. **함수 호출할 때는 캡쳐되지 않음.** 다만, 캡쳐한 변수를 참조하기 때문에 해당 변수값이 변하면 결과도 변함. 즉, **클로저가 속한 함수의 스코프 안에서 동작한다**고 생각하면 됨.

```swift
func makeIncrementer(forIncrement amount: Int) -> () -> Int {
	var runningTotal = 0
	func incrementer() -> Int {
		runningTotal += amount
		return runningTotal
	}
	return incrementer
}

let incrementByTen = makeIncrementer(forIncrement: 10)
print(incrementByTen()) //10
print(incrementByTen()) //20
let incrementBy7 = makeIncrementer(forIncrement: 7)
print(incrementBy7()) //7
print(incrementByTen()) //30
```

- map, filter, reduce 클로저: Collection Type에 사용 가능하다. **단, 중간에 빠져나올 수는 없다.** 다 돈다고 생각해야 함.
- **reduce**: **차원이 1개 감소한다**고 생각하면 됨. reduce의 첫번째 원소 **$0는 첫번째 파라미터**임.
- **map**은 옵셔널 사용 시 결과값에 옵셔널을 적용해서 반환.
- 반면, **flatMap**은 reduce와 같이 차원을 하나 줄여준다고 생각하면 됨. **옵셔널을 펼쳐주거나, 문자열인 경우 문자 하나하나로 펼쳐주거나 등.**

<br/>

## 추상화, 참조의 차이
- 객체를 잘 짜기 위해서는 **SOLID**.
- 객체를 struct로 짜거나 class로 짤 때에는 판단 기준이 필요.
- **Copy On Write (COW)** : 우선 참조만. **수정이 발생할 때 값을 복사**함. 예를 들어, String에서 일부 문자열을 자르면 Substring 타입이 되는데, Substring 타입은 참조형태로 작용하기 때문에 원본 String이 없어지면 Substring도 같이 없어짐. 또, Substring을 String으로 바꾸는 등 수정이 발생하면 그 때 값이 복사됨.
