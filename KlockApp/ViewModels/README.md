##  PassthroughSubject

SwiftUI와 Combine 프레임워크를 사용하는 Swift 프로그래밍 언어에서 PassthroughSubject는 Combine 프레임워크의 일부로 제공되는 유형의 퍼블리셔(publisher)입니다. PassthroughSubject는 데이터를 방출하거나 오류를 전파할 수 있으며, 해당 데이터를 구독자(subscribers)에게 전달합니다.

PassthroughSubject는 다음과 같은 특징을 가집니다:

1. **가변 상태를 가지지 않습니다.** 즉, 값을 저장하거나 버퍼링하지 않으며, 구독자가 연결되면 즉시 값을 전달합니다.
2. **브로드캐스트를 지원합니다.** 여러 구독자에게 동시에 값을 전달할 수 있습니다.
3. **외부에서 값을 전달받아 구독자에게 전달하는데 사용됩니다.** 이를 통해 다양한 이벤트나 값의 변화를 구독자에게 알릴 수 있습니다.

PassthroughSubject를 생성하려면 두 가지 타입 인자를 제공해야 합니다: Output 및 Failure. Output은 퍼블리셔가 방출하는 값의 유형을 나타내며, Failure는 퍼블리셔가 전파할 수 있는 오류의 유형을 나타냅니다.

```swift
import Combine

enum CustomError: Error {
    case someError
}

// Int 값을 방출하고 실패로 CustomError 타입을 사용하는 PassthroughSubject는 다음과 같이 생성할 수 있습니다:
let passthroughSubject = PassthroughSubject<Int, CustomError>()

// PassthroughSubject를 구독하려면, 구독자의 sink(receiveCompletion:receiveValue:) 메서드를 사용하여 구독할 수 있습니다:
let subscription = passthroughSubject.sink { completion in
    print("1 Completed with: \(completion)")
} receiveValue: { value in
    print("1 Received value: \(value)")
}

let subscription2 = passthroughSubject.sink { completion in
    print("2 Completed with: \(completion)")
} receiveValue: { value in
    print("2 Received value: \(value)")
}

// PassthroughSubject를 사용하여 데이터를 전달하려면, send(_:) 메서드를 사용하여 값을 전달할 수 있습니다:
passthroughSubject.send(42) // 구독이 2번 이뤄졌으니깐 2번 출력 됨
passthroughSubject.send(completion: .finished)  // 구독이 2번 이뤄졌으니깐 2번 출력 됨
passthroughSubject.send(35) // 출력 안됨

//    1 Received value: 42
//    2 Received value: 42
//    1 Completed with: finished
//    2 Completed with: finished
```
