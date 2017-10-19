

## 기타

### 삼항연산자
> Conditional operator - () : () ? ()
> Nil-coalescing operator - ??
 

### Error Handling
> throws : 함수를 실행하다가 중간에 돌아올 수 있다는 뜻.
> 중간에 빠져나올 수 있는 함수는 실행 시 do { try } catch가 필요함.

`
func makeASandwich() throws {
	...
}
`

`
do{
	try makeASandwich()
}catch 조건비교 {
	다른동작
}
`

> 반면, 리턴타입이 옵셔널 타입인 경우, 반환값만 가지고 예외처리를 할 수 있기 때문에 중간에 돌아올 필요가 없기 때문에 do-try는 필요없다.


- 옵셔널타입 으로 반환(권장)
 
`let result = try? buySandwich()` 

- 값타입 으로 반환

`let result = try! buySandwich()` 



### XCode
> break point를 잡으면 그 줄 직전까지만 실행되고 멈춤. break point 잡은 줄부터 한 줄씩 실행 가능.
