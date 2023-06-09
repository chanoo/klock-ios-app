//
//  PomodoroTimerRemoteServiceTests.swift
//  KlockAppTests
//
//  Created by 성찬우 on 2023/05/07.
//

import XCTest
import Combine
@testable import KlockApp

class PomodoroTimerRemoteServiceTests: XCTestCase {
    var sut: PomodoroTimerRemoteService!
    var subscriptions = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        sut = PomodoroTimerRemoteService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testCreatePomodoroTimer() {
        let expectation = XCTestExpectation(description: "Create Pomodoro Timer")

        let pomodoroTimer = ReqPomodoroTimer(seq: 1, name: "Pomodoro Timer", focusTime: 30, breakTime: 5, cycleCount: 4)

        sut.create(data: pomodoroTimer)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    XCTFail("Create Pomodoro Timer failed with error: \(error)")
                case .finished:
                    break
                }
                expectation.fulfill()
            }, receiveValue: { timer in
                XCTAssertEqual(timer.name, pomodoroTimer.name)
            })
            .store(in: &subscriptions)

        wait(for: [expectation], timeout: 10)
    }

    func testUpdatePomodoroTimer() {
        let expectation = XCTestExpectation(description: "Update Pomodoro Timer")

        let pomodoroTimer = ReqPomodoroTimer(seq: 1, name: "Pomodoro Timer", focusTime: 30, breakTime: 5, cycleCount: 4)

        sut.update(id: 49, data: pomodoroTimer)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    XCTFail("Update Pomodoro Timer failed with error: \(error)")
                case .finished:
                    break
                }
                expectation.fulfill()
            }, receiveValue: { timer in
                XCTAssertEqual(timer.name, pomodoroTimer.name)
            })
            .store(in: &subscriptions)

        wait(for: [expectation], timeout: 10)
    }

    func testDeletePomodoroTimer() {
        let expectation = XCTestExpectation(description: "Delete Pomodoro Timer")

        let pomodoroTimerId: Int64 = 52

        sut.delete(id: pomodoroTimerId)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    XCTFail("Delete Pomodoro Timer failed with error: \(error)")
                case .finished:
                    break
                }
                expectation.fulfill()
            }, receiveValue: { _ in })
            .store(in: &subscriptions)

        wait(for: [expectation], timeout: 10)
    }

}
