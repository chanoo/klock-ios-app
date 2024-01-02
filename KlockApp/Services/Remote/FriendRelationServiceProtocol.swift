//
//  FriendRelationServiceProtocol.swift
//  KlockApp
//
//  Created by 성찬우 on 11/8/23.
//

import Combine
import Alamofire

protocol FriendRelationServiceProtocol {
    func fetch() -> AnyPublisher<[FriendRelationFetchResDTO], AFError>
    func followQRCode(request: FriendRelationFollowQRCodeReqDTO) -> AnyPublisher<FriendRelationFollowQRCodeResDTO, Alamofire.AFError>
//    func follow(followId: Int64) -> AnyPublisher<ResStudySession, AFError>
//    func unfollow(followId: Int64) -> AnyPublisher<ResStudySession, AFError>
}
