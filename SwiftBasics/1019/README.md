## 사다리 게임 요구사항

간단한 사다리 게임을 구현한다.
n개의 사람과 m개의 사다리 개수를 입력할 수 있어야 한다.
사다리는 랜덤으로 있거나 없을 수도 있다.
사다리가 있으면 -를 표시하고 없으면 " " 빈공백을 표시한다. 양옆에는 |로 세로를 표시한다.
사다리 상태를 화면에 출력한다. 어느 시점에 출력할 것인지에 대한 제약은 없다.


## 기타

### 삼항연산자
> Conditional operator - () : () ? ()
> Nil-coalescing operator - ??
 

### Error Handling
> throws : 함수를 실행하다가 중간에 돌아올 수 있다는 뜻.
> 중간에 빠져나올 수 있는 함수는 실행 시 do { try } catch가 필요함.

- 정의부

```
func makeASandwich() throws {
	...
}
```

- 호출부

```
do{
	try makeASandwich()
}catch 조건비교 {
	다른동작
}
```


- 반면, 리턴타입이 옵셔널 타입인 경우, 반환값만 가지고 예외처리를 할 수 있기 때문에 중간에 돌아올 필요가 없기 때문에 do-try는 필요없다.

 
`let result = try? buySandwich()` 

> 옵셔널타입 으로 반환(권장)

`let result = try! buySandwich()` 

> 값타입 으로 반환


### XCode
> break point를 잡으면 그 줄 직전까지만 실행되고 멈춤. break point 잡은 줄부터 한 줄씩 실행 가능.
