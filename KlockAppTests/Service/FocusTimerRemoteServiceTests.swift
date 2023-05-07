//
//  FocusTimerRemoteServiceTests.swift
//  KlockAppTests
//
//  Created by 성찬우 on 2023/05/07.
//

import XCTest
import Combine
@testable import KlockApp

class FocusTimerRemoteServiceTests: XCTestCase {
    var sut: FocusTimerRemoteService!
    var subscriptions = Set<AnyCancellable>()
    var timerId: Int64?

    override func setUp() {
        super.setUp()
        sut = FocusTimerRemoteService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testCreateFocusTimer() {
        let expectation = XCTestExpectation(description: "Create Focus Timer")

        let focusTimer = FocusTimerDTO(id: nil, userId: 2, seq: 1, type: "focus", name: "Focus Timer")

        sut.create(data: focusTimer)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    XCTFail("Create Focus Timer failed with error: \(error)")
                case .finished:
                    break
                }
                expectation.fulfill()
            }, receiveValue: { timer in
                self.timerId = timer.id
                XCTAssertEqual(timer.name, focusTimer.name)
            })
            .store(in: &subscriptions)

        wait(for: [expectation], timeout: 10)
    }

    func testUpdateFocusTimer() {
        let expectation = XCTestExpectation(description: "Update Focus Timer")

        let focusTimer = FocusTimerDTO(id: 27, userId: 1, seq: 1, type: "focus", name: "Updated Timer")

        sut.update(id: focusTimer.id ?? 0, data: focusTimer)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    XCTFail("Update Focus Timer failed with error: \(error)")
                case .finished:
                    break
                }
                expectation.fulfill()
            }, receiveValue: { timer in
                XCTAssertEqual(timer.name, focusTimer.name)
            })
            .store(in: &subscriptions)

        wait(for: [expectation], timeout: 10)
    }

    func testDeleteFocusTimer() {
        let expectation = XCTestExpectation(description: "Delete Focus Timer")

        let focusTimerId: Int64 = 30

        sut.delete(id: focusTimerId)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    XCTFail("Delete Focus Timer failed with error: \(error)")
                case .finished:
                    break
                }
                expectation.fulfill()
            }, receiveValue: { _ in })
            .store(in: &subscriptions)

        wait(for: [expectation], timeout: 10)
    }

}
