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
    
    func testSearchByNickname() {
        let expectation = XCTestExpectation(description: "닉네임으로 검색")

        let nickname = "차누우" // 검색할 예제 닉네임

        sut.searchBy(nickname: nickname)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    XCTFail("닉네임으로 검색 실패, 에러: \(error)")
                case .finished:
                    break
                }
                expectation.fulfill()
            }, receiveValue: { response in
                XCTAssertNotNil(response, "응답이 nil이 아니어야 함")
                // 응답이 닉네임과 일치하는 사용자의 배열이나 단일 사용자를 포함한다고 가정합니다.
                // 예상되는 `SearchByNicknameResDTO`의 구조에 따라 여기에 더 많은 단언을 추가할 수 있습니다.
                // 예를 들어, 배열의 사용자인 경우:
                XCTAssertFalse(response!.nickname.isEmpty, "주어진 닉네임으로 적어도 한 명의 사용자를 찾아야 함")
                // 또는 단일 사용자 응답인 경우:
                // XCTAssertEqual(response.nickname, nickname, "반환된 닉네임은 요청된 닉네임과 일치해야 함")
            })
            .store(in: &subscriptions)

        wait(for: [expectation], timeout: 10.0)
    }
}
