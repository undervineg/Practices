## 스위프트의 확장기능
- 서브스크립트: 구조체에 구현하면 좋음.
- 클래스의 확장 방법은 ‘상속’이 있으나, 요즘에는 ‘상속’을 권장하지 않음 —> 프로토콜, 익스텐션, 제네릭 으로 대체하도록.

### 1. 확장: 프로토콜
- 타입이 구현해야 하는 함수 또는 프로퍼티 목록
- 여러 타입에 공통적으로 있어야 하는 함수나 프로퍼티 등을 같은 인터페이스로 구현 가능하다.
- 상속을 쓰면 프로토콜에 비해 제약이 많기 때문에 프로토콜을 쓰면 확장성이 더 좋다.(다형성)
- struct, enum은 상속이 안되기 때문에 같은 인터페이스를 쓰는 경우, 프로토콜을 사용하도록 권장.
* 해시(hash) : 큰 값을 수학적으로 축약시켜서 큰 값끼리 비교/저장 하는 대신, 해시값을 사용하여 비교/검색하여 큰 값을 대신 비교하거나 큰 값을 찾아갈 수 있음. 객체들의 속성을 다 비교하지 않고 해시값을 비교하거나 해시값으로 검색하여 객체를 찾아가는 등에 쓰임.
* 정적 타이핑 vs 동적 타이핑 : swift는 정적타이핑에 가깝지만, 동적타이핑을 지향함. 동적타이핑은 구현하지 않은 함수라도 처리할 수 있는 방법들을 제공함. 동적타이핑은 덕 타이핑(duck typing)이라고도 하는데, 어떤 새가 오리처럼 걷고, 헤엄치고, 꽥꽥거린다면 그 새를 오리라고 부를 수 있다는 개념이다.([참고: 덕타이핑](https://ko.wikipedia.org/wiki/덕_타이핑)) 즉, 객체의 타입보다 객체가 사용되는 양상이 더 중요하다고 보는 입장.

### 2. 확장: 익스텐션
- 나만의 기능 추가. 수평적 확장. (상속처럼 수직 확장이 아닌)
- 프로토콜 단위로 익스텐션을 만드는 것이 권장됨. 기능 단위로 명확하게 분리할 수 있기 때문.
- 재정의 불가: 함수든 변수든 원래 있는 건 추가가 안 됨.
- 상속을 하게 되면 구현해야 하는 걸 구현하지 못 하는 경우도 있고, 애플은 디자인 패턴 상 숨겨놓은 부모를 만들어놓은 경우가 있어서 프로토콜을 사용하는 것이 좋음

### 3. 확장: 제너릭
- 타입 추상화: 타입만 다르고 동작이 다 똑같은 경우에 사용.