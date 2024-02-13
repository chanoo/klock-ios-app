import Combine
import Foundation

//enum CustomError: Error {
//    case someError
//}
//
//let passthroughSubject = PassthroughSubject<Int, CustomError>()
//
//let subscription = passthroughSubject.sink { completion in
//    print("1 Completed with: \(completion)")
//} receiveValue: { value in
//    print("1 Received value: \(value)")
//}
//
//let subscription2 = passthroughSubject.sink { completion in
//    print("2 Completed with: \(completion)")
//} receiveValue: { value in
//    print("2 Received value: \(value)")
//}
//
//passthroughSubject.send(42) // 구독이 2번 이뤄졌으니깐 2번 출력 됨
//passthroughSubject.send(completion: .finished)  // 구독이 2번 이뤄졌으니깐 2번 출력 됨
//passthroughSubject.send(35) // 출력 안됨

//    1 Received value: 42
//    2 Received value: 42
//    1 Completed with: finished
//    2 Completed with: finished




let concurrentQueue = DispatchQueue(label: "app.klock.myConcurrentQueue", attributes: .serial)

concurrentQueue.async {
    for i in 1...5 {
        print("Task 1, iteration \(i)")
    }
}

concurrentQueue.async {
    for i in 1...5 {
        print("Task 2, iteration \(i)")
    }
}
