### 간접참조
> 컴퓨터 공학에서 "간접 참조"는 값 자체보다 컨테이너, 연결, 별명 등을 사용해서 우회해서 참조하도록 하는 방식을 말함


### 이미 만들어놓은 함수들
> print, zip, swap, stride, readLine, min, max, abs, assert, assertionFailure, debugPrint, dump, fatalError, getVaList, isKnownUniquelyReferenced, numericCast, precondition, preconditionFailure, repeatElement, sequence, stride, transcode, unsafeBitCast, unsafeDowncast, withExtendedLifetime, withUnsafeMutablePointer, withUnsafePointer, withVaList를 자주 씀


### 데이터 타입
> swift에서는 Int, String, Double, Bool 등의 원시타입이 구조체로 구현되어 있다.


### 함수
> 선언부와 호출부는 항상 나뉘게 될 것이다.


### 문자열
#### Search Strings (검색)
> Range를 자주 씀. 범위연산자.


#### A View of String
> String.unicodeScalars


### 옵셔널
박스로 값을 감싼 형태


### 삼항연산자
>- Conditional operator - **() : () ? ()**
>
>- Nil-coalescing operator - **??**
 

### Error Handling
>- throws : 함수를 실행하다가 중간에 돌아올 수 있다는 뜻.
> 
>- 중간에 빠져나올 수 있는 함수는 실행 시 do { try } catch가 필요함.

- 정의부

```swift
func makeASandwich() throws {
	...
}
```

- 호출부

```swift
do{
	try makeASandwich()
}catch 조건비교 {
	다른동작
}
```


- 반면, 리턴타입이 옵셔널 타입인 경우, 반환값만 가지고 예외처리를 할 수 있기 때문에 중간에 돌아올 필요가 없기 때문에 do-try는 필요없다.

 
`let result = try? buySandwich()` : 옵셔널타입 으로 반환(권장)

`let result = try! buySandwich()` : 값타입 으로 반환

<br/>

### 타입 메소드
- 타입메소드는 타입변수에만 접근이 가능. 인스턴스를 만드는 경우에는 인스턴스 내의 고유한 값들이 있는데, 타입메소드는 인스턴스 없이도 호출이 가능하기 때문임.
- class 와 struct 에 쓸 수 있는데, class에는 class 키워드로 쓸 수 있고, static과는 상속 가능 여부로 차이가 남.

<br/>

### 열거형 타입
- 사용하는 경우:
    - 제한된 선택지를 주고 싶을 때
    - 정해진 값 외에는 입력받고 싶지 않을 때
    - 예상된 입력값이 한정되어 있을 때
    - 상태에 따라 값이 변할 때
- 바코드 예시 -> struct로 만들 수도 있지만 enum으로 만들면 더 깔끔해보임.
* 스위프트 철학: class보다 적합한 타입이 있다면, struct나 enum 등을 써라.

<br/>

### Switch 문
- if문보다 성능이 더 좋음.
- 열거형과 함께 쓰면, 컴파일러가 switch 케이스에서 빠진 부분을 알려줌.
- 복잡한 비교는 switch-case문으로 : 튜플타입으로 비교 가능. 단, 구체적인 것일 수록 위쪽에 적는다. 중복되는 경우 위에서 걸리면 아래는 패스되기 때문.
