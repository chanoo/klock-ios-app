//
//  ExamTimerRemoteServiceTests.swift
//  KlockAppTests
//
//  Created by 성찬우 on 2023/05/07.
//

import XCTest
import Combine
@testable import KlockApp

class ExamTimerRemoteServiceTests: XCTestCase {
    var sut: ExamTimerRemoteService!
    var subscriptions = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        sut = ExamTimerRemoteService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testCreateExamTimer() {
        let expectation = XCTestExpectation(description: "Create Exam Timer")

        let examTimer = ExamTimerDTO(id: nil, userId: 2, seq: 1, type: nil, name: "Test Exam Timer", startTime: "2023-04-30T01:22:41.171737", duration: 90, questionCount: 30)

        sut.create(data: examTimer)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    XCTFail("Create Exam Timer failed with error: \(error)")
                case .finished:
                    break
                }
                expectation.fulfill()
            }, receiveValue: { timer in
                XCTAssertEqual(timer.name, examTimer.name)
            })
            .store(in: &subscriptions)

        wait(for: [expectation], timeout: 10)
    }

    func testUpdateExamTimer() {
        let expectation = XCTestExpectation(description: "Update Exam Timer")
        
        let examTimer = ExamTimerDTO(id: 9, userId: 2, seq: 1, type: nil, name: "Update Exam Timer", startTime: "2023-04-30T01:22:41.171737", duration: 90, questionCount: 30)

        sut.update(id: examTimer.id ?? 0, data: examTimer)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    XCTFail("Update Exam Timer failed with error: \(error)")
                case .finished:
                    break
                }
                expectation.fulfill()
            }, receiveValue: { timer in
                XCTAssertEqual(timer.name, examTimer.name)
            })
            .store(in: &subscriptions)

        wait(for: [expectation], timeout: 10)
    }

    func testDeleteTimer() {
        let expectation = XCTestExpectation(description: "Delete Exam Timer")

        let examTimerId: Int64 = 30

        sut.delete(id: examTimerId)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    XCTFail("Delete Exam Timer failed with error: \(error)")
                case .finished:
                    break
                }
                expectation.fulfill()
            }, receiveValue: { _ in })
            .store(in: &subscriptions)

        wait(for: [expectation], timeout: 10)
    }

}
