//
//  UserRemoteServiceProtocol.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/07/07.
//

import Foundation
import Combine
import Alamofire

protocol UserRemoteServiceProtocol {
    func existed(nickname: String) -> AnyPublisher<ExistedNicknameResDTO, AFError>
    func delete(id: Int64) -> AnyPublisher<Void, AFError>
    func get(id: Int64) -> AnyPublisher<GetUserResDTO, AFError>
    func update(id: Int64, request: UserUpdateReqDTO) -> AnyPublisher<ProfileImageResDTO, AFError>
    func profileImage(id: Int64, request: ProfileImageReqDTO) -> AnyPublisher<ProfileImageResDTO, Alamofire.AFError>
}
