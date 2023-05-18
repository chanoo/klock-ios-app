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

        let reqFocusTimer = ReqFocusTimer(seq: 1, name: "집중 시간 타이머")

        sut.create(data: reqFocusTimer)
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
                XCTAssertEqual(timer.name, reqFocusTimer.name)
            })
            .store(in: &subscriptions)

        wait(for: [expectation], timeout: 10)
    }

    func testUpdateFocusTimer() {
        let expectation = XCTestExpectation(description: "Update Focus Timer")

        let id: Int64 = 19
        let reqFocusTimer = ReqFocusTimer(seq: 1, name: "수정된 집중 시간 타이머")

        sut.update(id: id, data: reqFocusTimer)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    XCTFail("Update Focus Timer failed with error: \(error)")
                case .finished:
                    break
                }
                expectation.fulfill()
            }, receiveValue: { timer in
                XCTAssertEqual(timer.name, reqFocusTimer.name)
            })
            .store(in: &subscriptions)

        wait(for: [expectation], timeout: 10)
    }

    func testDeleteFocusTimer() {
        let expectation = XCTestExpectation(description: "Delete Focus Timer")

        let focusTimerId: Int64 = 31

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
