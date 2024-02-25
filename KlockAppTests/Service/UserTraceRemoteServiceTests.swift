//
//  UserTraceRemoteServiceTests.swift
//  KlockAppTests
//
//  Created by 성찬우 on 2/13/24.
//

import XCTest
import Combine
@testable import KlockApp

class UserTraceRemoteServiceTests: XCTestCase {
    var sut: UserTraceRemoteService!
    var subscriptions = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        sut = UserTraceRemoteService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testFetchUserTraces() {
        let expectation = XCTestExpectation(description: "Fetch User Traces")

        sut.fetch(page: 0)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    XCTFail("Fetch failed with error: \(error)")
                case .finished:
                    break
                }
                expectation.fulfill()
            }, receiveValue: { response in
                XCTAssertFalse(response.isEmpty, "Response should not be empty")
                // Perform additional assertions as necessary
            })
            .store(in: &subscriptions)

        wait(for: [expectation], timeout: 10.0)
    }

    func testCreateUserTraceWithImage() {
        let expectation = XCTestExpectation(description: "Create User Trace")
        
        let createReqDTO = UserTraceCreateReqDTO(
            contentTrace: UserTraceCreateReqContentTraceDTO(writeUserId: 128, type: .activity, contents: "Sample content 오직 텍스트 뿐인 글입니다."),
            image: nil)

        sut.create(data: createReqDTO)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    XCTFail("Creation failed with error: \(error)")
                case .finished:
                    break
                }
                expectation.fulfill()
            }, receiveValue: { response in
                XCTAssertEqual(response.writeUserId, createReqDTO.contentTrace.writeUserId, "Response writeUserId should match request writeUserId")
                XCTAssertEqual(response.contents, createReqDTO.contentTrace.contents, "Response contents should match request contents")
                // Add more assertions as needed
            })
            .store(in: &subscriptions)

        wait(for: [expectation], timeout: 10.0)
    }
    
    func testCreateUserTrace() {
        let expectation = XCTestExpectation(description: "Create User Trace With Image")
        
        let dummyImageData = UIImage(systemName: "photo")!.jpegData(compressionQuality: 0.5)!

        let createReqDTO = UserTraceCreateReqDTO(contentTrace: UserTraceCreateReqContentTraceDTO(writeUserId: 128, type: .activity, contents: "Sample content ??"), image: dummyImageData)

        sut.create(data: createReqDTO)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    XCTFail("Creation failed with error: \(error)")
                case .finished:
                    break
                }
                expectation.fulfill()
            }, receiveValue: { response in
                XCTAssertEqual(response.writeUserId, createReqDTO.contentTrace.writeUserId, "Response writeUserId should match request writeUserId")
                XCTAssertEqual(response.contents, createReqDTO.contentTrace.contents, "Response contents should match request contents")
                // Add more assertions as needed
            })
            .store(in: &subscriptions)

        wait(for: [expectation], timeout: 10.0)
    }

//    func testDeleteUserTrace() {
//        let expectation = XCTestExpectation(description: "Delete User Trace")
//
//        let id: Int64 = 6 // Assume this is a valid ID for deletion
//
//        sut.delete(id: id)
//            .sink(receiveCompletion: { result in
//                switch result {
//                case .failure(let error):
//                    XCTFail("Deletion failed with error: \(error)")
//                case .finished:
//                    break
//                }
//                expectation.fulfill()
//            }, receiveValue: { _ in
//                // Success case, maybe verify deletion with a fetch if possible
//            })
//            .store(in: &subscriptions)
//
//        wait(for: [expectation], timeout: 10.0)
//    }
}
