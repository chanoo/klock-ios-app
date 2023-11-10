//
//  FriendRelationService.swift
//  KlockApp
//
//  Created by 성찬우 on 11/17/23.
//

import Alamofire
import Combine

class FriendRelationService: FriendRelationServiceProtocol, APIServiceProtocol {    
    private let baseURL = "https://api.klock.app/api/v1/friend-relations"
    
    func fetch() -> AnyPublisher<[FriendRelationFetchResDTO], Alamofire.AFError> {
        let url = "\(baseURL)"

        return AF.request(url, method: .get, encoding: JSONEncoding.default)
            .validate()
            .publishDecodable(type: [FriendRelationFetchResDTO].self)
            .value()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }

//    func follow(followId: Int64) -> AnyPublisher<ResStudySession, Alamofire.AFError> {
//        
//    }
//    
//    func unfollow(followId: Int64) -> AnyPublisher<ResStudySession, Alamofire.AFError> {
//        
//    }
}
