//
//  FriendRelationService.swift
//  KlockApp
//
//  Created by 성찬우 on 11/17/23.
//

import Alamofire
import Combine
import Foundation

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
        let url = "http://192.168.68.73:8080/api/v1/friend-relations/follow/qr-code"

        return session.request(url, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: self.headers())
            .validate()
            .publishDecodable(type: FriendRelationFollowQRCodeResDTO.self)
            .value()
            .eraseToAnyPublisher()
    }
    
    func follow(followId: Int64) -> AnyPublisher<FriendRelationFollowResDTO, Alamofire.AFError> {
        let url = "\(baseURL)/follow"
        let requestDTO = FriendRelationFollowReqDTO(followId: followId)

        return session.request(url, method: .post, parameters: requestDTO.dictionary, encoding: JSONEncoding.default, headers: self.headers())
            .validate()
            .publishDecodable(type: FriendRelationFollowResDTO.self)
            .tryMap { result -> FriendRelationFollowResDTO in
                switch result.result {
                case .success(let response):
                    return response
                case .failure(let error):
                    if let data = result.data {
                        let decoder = JSONDecoder()
                        if let errorResponse = try? decoder.decode(APIErrorModel.self, from: data) {
                            print("Server error message: \(errorResponse.error)")
                        }
                    }
                    throw error
                }
            }
            .mapError { error -> AFError in
                if let afError = error as? AFError {
                    return afError
                } else {
                    return AFError.sessionTaskFailed(error: error)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func unfollow(followId: Int64) -> AnyPublisher<Void, Alamofire.AFError> {
        let url = "\(baseURL)/unfollow"
        let requestDTO = FriendRelationUnfollowReqDTO(followId: followId)

        return session.request(url, method: .post, parameters: requestDTO.dictionary, encoding: JSONEncoding.default, headers: self.headers())
            .validate()
            .publishData()
            .tryMap { dataResponse -> Void in
                if let statusCode = dataResponse.response?.statusCode, statusCode >= 200, statusCode < 300 {
                    return ()
                } else {
                    throw dataResponse.error ?? AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: dataResponse.response?.statusCode ?? -1))
                }
            }
            .mapError { error -> AFError in
                if let afError = error as? AFError {
                    return afError
                } else {
                    return AFError.sessionTaskFailed(error: error)
                }
            }
            .eraseToAnyPublisher()
    }
}
