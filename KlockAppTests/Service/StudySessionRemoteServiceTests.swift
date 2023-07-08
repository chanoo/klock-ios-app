//
//  StudySessionRemoteServiceTests.swift
//  KlockAppTests
//
//  Created by 성찬우 on 2023/05/19.
//

import XCTest
import Combine
@testable import KlockApp

class StudySessionRemoteServiceTests: XCTestCase {
    var sut: StudySessionRemoteService!
    var subscriptions = Set<AnyCancellable>()
    var timerId: Int64?

    override func setUp() {
        super.setUp()
        sut = StudySessionRemoteService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testCreateFocusTimer() {
        let expectation = XCTestExpectation(description: "Create Study Session")

        let req = ReqStudySession(userId: 56, timerName: "집중시간 타이머", timerType: .focus, startTime: "2023-01-01T08:40:00", endTime: "2023-01-01T10:10:10")

        sut.create(data: req)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    XCTFail("Create Study Session failed with error: \(error)")
                case .finished:
                    break
                }
                expectation.fulfill()
            }, receiveValue: { timer in
                self.timerId = timer.id
                XCTAssertEqual(timer.startTime, req.startTime)
            })
            .store(in: &subscriptions)

        wait(for: [expectation], timeout: 10)
    }

    func testUpdateFocusTimer() {
        let expectation = XCTestExpectation(description: "Update Study Session")

        let id: Int64 = 1
        let req = ReqStudySession(userId: 56, timerName: "집중시간 타이머", timerType: .focus, startTime: "2023-01-01T08:40:00", endTime: "2023-01-01T10:10:10")

        sut.update(id: id, data: req)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    XCTFail("Update Study Session failed with error: \(error)")
                case .finished:
                    break
                }
                expectation.fulfill()
            }, receiveValue: { timer in
                XCTAssertEqual(timer.endTime, req.endTime)
            })
            .store(in: &subscriptions)

        wait(for: [expectation], timeout: 10)
    }
    
    func testFetchStudySession() {
        let expectation = XCTestExpectation(description: "Fetch Study Session")

        sut.fetch(userId: 88, startDate: "2023-06-01", endDate: "2023-07-08")
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    XCTFail("Fetch Study Session failed with error: \(error)")
                case .finished:
                    break
                }
                expectation.fulfill()
            }, receiveValue: { studySessions in
                XCTAssertEqual(studySessions.count > 0, true)
            })
            .store(in: &subscriptions)

        wait(for: [expectation], timeout: 10)
    }


}
