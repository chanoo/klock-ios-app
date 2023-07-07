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
    func existed(nickName: String) -> AnyPublisher<ExistedNickNameResDTO, AFError>
}
