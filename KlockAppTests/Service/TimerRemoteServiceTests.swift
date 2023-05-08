//
//  TimerRemoteServiceTests.swift
//  KlockAppTests
//
//  Created by 성찬우 on 2023/05/09.
//

import XCTest
import Combine
@testable import KlockApp

class TimerRemoteServiceTests: XCTestCase {
    var sut: TimerRemoteService!
    var subscriptions = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        sut = TimerRemoteService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testFetchTimers() {
        let expectation = XCTestExpectation(description: "Fetch Timers")

        sut.fetch()
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    XCTFail("Fetch Timers failed with error: \(error)")
                case .finished:
                    break
                }
                expectation.fulfill()
            }, receiveValue: { timers in
                XCTAssertNotNil(timers)
                XCTAssertGreaterThan(timers.count, 0)
            })
            .store(in: &subscriptions)

        wait(for: [expectation], timeout: 10)
    }
}
