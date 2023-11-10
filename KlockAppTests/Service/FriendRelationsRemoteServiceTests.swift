//
//  FriendRelationsRemoteServiceTests.swift
//  KlockAppTests
//
//  Created by 성찬우 on 11/17/23.
//

import XCTest
import Combine
@testable import KlockApp

class FriendRelationServiceTests: XCTestCase {
    var sut: FriendRelationService!
    var subscriptions = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        sut = FriendRelationService() // Initialize your service class here
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testFetchFriendRelations() {
        let expectation = XCTestExpectation(description: "Fetch Friend Relations")

        // Assuming the function `fetch` is part of a service, e.g., `FriendRelationService`
        sut.fetch()
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    XCTFail("Fetch Friend Relations failed with error: \(error)")
                case .finished:
                    break
                }
                expectation.fulfill()
            }, receiveValue: { friendRelations in
                XCTAssertNotNil(friendRelations, "No friend relations returned")
                // You can add more assertions here to validate the fetched data.
            })
            .store(in: &subscriptions)

        wait(for: [expectation], timeout: 10)
    }
}
