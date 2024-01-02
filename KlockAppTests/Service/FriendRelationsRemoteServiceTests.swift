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
    var sut: FriendRelationService! // 서비스 클래스를 테스트하기 위한 인스턴스
    var subscriptions = Set<AnyCancellable>() // Combine을 사용한 비동기 작업을 관리하는 구독 집합

    override func setUp() {
        super.setUp()
        sut = FriendRelationService() // 여기에서 서비스 클래스를 초기화
    }

    override func tearDown() {
        sut = nil // 테스트 종료 후 인스턴스 해제
        super.tearDown()
    }

    // 친구 관계 정보를 가져오는 기능 테스트
    func testFetchFriendRelations() {
        let expectation = XCTestExpectation(description: "Fetch Friend Relations")

        // `fetch` 함수가 `FriendRelationService`의 일부라고 가정
        sut.fetch()
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    XCTFail("Fetch Friend Relations 실패: \(error)")
                case .finished:
                    break
                }
                expectation.fulfill()
            }, receiveValue: { friendRelations in
                XCTAssertNotNil(friendRelations, "친구 관계 정보가 반환되지 않음")
                // 여기에 더 많은 검증을 추가할 수 있음
            })
            .store(in: &subscriptions)

        wait(for: [expectation], timeout: 10)
    }
    
    // QR 코드를 사용하여 친구를 팔로우하는 기능 테스트
    func testFollowQRCode() {
        let expectation = XCTestExpectation(description: "Follow Friend Using QR Code")

        // 모의 요청 객체 생성
        let request = FriendRelationFollowQRCodeReqDTO(followData: "data", encryptedKey: "key")

        // `followQRCode` 함수를 모의 요청과 함께 호출
        sut.followQRCode(request: request)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    XCTFail("Follow Friend Using QR Code 실패: \(error)")
                case .finished:
                    break
                }
                expectation.fulfill()
            }, receiveValue: { response in
                // 응답을 검증하는 단언문
                XCTAssertNotNil(response, "Follow QR Code에 대한 응답 없음")
            })
            .store(in: &subscriptions)

        wait(for: [expectation], timeout: 10)
    }

}
