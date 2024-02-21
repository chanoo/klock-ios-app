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
    
    private let logger = AlamofireLogger()
    private let session: Session

    init() {
        session = Session(eventMonitors: [logger])
    }
    
    func fetch() -> AnyPublisher<[FriendRelationFetchResDTO], Alamofire.AFError> {
        let url = "\(baseURL)"
        
        return session.request(url, method: .get, encoding: JSONEncoding.default, headers: self.headers())
            .validate()
            .publishDecodable(type: [FriendRelationFetchResDTO].self)
            .value()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }

    func followQRCode(request: FriendRelationFollowQRCodeReqDTO) -> AnyPublisher<FriendRelationFollowQRCodeResDTO, Alamofire.AFError> {
        let url = "\(baseURL)/follow/qr-code"

        return session.request(url, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: self.headers())
            .validate()
            .publishDecodable(type: FriendRelationFollowQRCodeResDTO.self)
            .value()
            .eraseToAnyPublisher()
    }
}
