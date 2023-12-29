//
//  UserRemoteServiceTests.swift
//  KlockAppTests
//
//  Created by 성찬우 on 12/28/23.
//

import XCTest
import Combine
@testable import KlockApp

class UserRemoteServiceTests: XCTestCase {
    var sut: UserRemoteService!
    var subscriptions = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        sut = UserRemoteService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testUpdateUserInformation() {
        let expectation = XCTestExpectation(description: "Update User Information")

        // Assuming you have a valid user ID to test with
        let id: Int64 = 128
        let requestDTO = UserUpdateReqDTO(nickname: "닉네임", tagId: 3, startOfTheWeek: "MONDAY", startOfTheDay: 8)

        sut.update(id: id, request: requestDTO)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    XCTFail("Update failed with error: \(error)")
                case .finished:
                    break
                }
                expectation.fulfill()
            }, receiveValue: { response in
                XCTAssertEqual(response.id, id, "Response ID should match the user ID")
                XCTAssertEqual(response.nickname, requestDTO.nickname, "Nickname should be updated")
                // Add more assertions as needed based on the expected response
            })
            .store(in: &subscriptions)

        wait(for: [expectation], timeout: 10.0)
    }

    func testProfileImageUpload() {
        let expectation = XCTestExpectation(description: "Profile Image Upload")

        let id: Int64 = 128 // Example user ID
        let imageData = Data() // Replace this with actual image data for testing

        let requestDTO = ProfileImageReqDTO(file: imageData)

        sut.profileImage(id: id, request: requestDTO)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    XCTFail("Profile image upload failed with error: \(error)")
                case .finished:
                    break
                }
                expectation.fulfill()
            }, receiveValue: { response in
                XCTAssertEqual(response.id, id, "Response ID should match request ID")
                // Add more assertions as needed based on the expected response
            })
            .store(in: &subscriptions)

        wait(for: [expectation], timeout: 60.0)
    }
}
