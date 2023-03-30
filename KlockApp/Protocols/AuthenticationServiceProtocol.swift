//
//  AuthenticationServiceProtocol.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/03/30.
//

import Foundation
import Combine
import Alamofire

protocol AuthenticationServiceProtocol {
    func signIn(email: String, password: String) -> AnyPublisher<Account, AFError>
    func signInWithFacebook(accessToken: String) -> AnyPublisher<Account, AFError>
    func signInWithApple(accessToken: String) -> AnyPublisher<Account, AFError>
}
