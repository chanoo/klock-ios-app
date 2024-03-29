//
//  UserTraceRemoteServiceProtocol.swift
//  KlockApp
//
//  Created by 성찬우 on 2/13/24.
//

import Combine
import Alamofire

protocol UserTraceRemoteServiceProtocol {
    func fetch(userId: Int64, page: Int, size: Int?) -> AnyPublisher<[UserTraceResDTO], AFError>
    func create(data: UserTraceCreateReqDTO) -> AnyPublisher<UserTraceResDTO, AFError>
    func delete(id: Int64) -> AnyPublisher<Void, AFError>
    func addHeart(id: Int64, heartCount: Int) -> AnyPublisher<UserTraceAddHeartResDTO, AFError>
}
