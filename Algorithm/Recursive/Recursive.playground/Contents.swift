// 재귀기초
func fact(_ num: Int) -> Int{
    if num == 1 {
        return 1
    }
    return num * fact(num-1)
}

//fact(5)

// 점화식: 재귀나 다이나믹 프로그래밍으로 문제를 풀 때 유용하게 사용 가능
// an = 7n+1 (n>=0)
func diff(_ n: Int) -> Int{
    if n == 0{
        return 1
    }
    return diff(n-1) + 7
}

//diff(5)

// 피보나치 수열: 복잡도는.. O(2^n) 이라고 볼 수 있다.
func fibo(_ n: Int) -> Int{
    if n == 0 || n == 1{
        return 1
    }
    return fibo(n-2) + fibo(n-1)
}

fibo(5)

// 피보나치 수열을 보면 같은 함수를 중복해서 부른다.
// 이전에 부른 결과를 저장해놓고 꺼내쓰는 것을 다이나믹 프로그래밍의 메모이제이션이라고 한다.(메모장 활용하는 것과 같다 하여)
var memoArr: [Int] = Array.init(repeating: 0, count: 50)
func dynamicFibo(_ n: Int) -> Int{
    if n == 0 || n == 1 {
        memo[n] = 1
        return 1
    }
    // 처음하는 경우
    guard memoArr[n] == 0 else {
        memoArr[n] = dynamicFibo(n-2) + dynamicFibo(n-1)
    }
    return memoArr[n]
}

dynamicFibo(5)
