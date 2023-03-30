//
//  AuthenticationService.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/03/30.
//

import Foundation
import Alamofire
import Combine

class AuthenticationService: AuthenticationServiceProtocol {
    
    private let baseURL = "https://api.klock.app/api/auth"

    // 로그인 함수
    func signIn(email: String, password: String) -> AnyPublisher<Account, AFError> {
        let url = "\(baseURL)/signin"
        let parameters: [String: Any] = ["email": email, "password": password]

        return AF.request(url, method: .post, parameters: parameters)
            .validate()
            .publishDecodable(type: Account.self)
            .value()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }

    func signInWithFacebook(accessToken: String) -> AnyPublisher<Account, AFError> {
        let url = "\(baseURL)/signin-with-facebook"
        let parameters: [String: Any] = ["accessToken": accessToken]

        return AF.request(url, method: .post, parameters: parameters)
            .validate()
            .publishDecodable(type: Account.self)
            .value()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    func signInWithApple(accessToken: String) -> AnyPublisher<Account, AFError> {
        let url = "\(baseURL)/signin-with-apple"
        let parameters: [String: Any] = ["accessToken": accessToken]

        return AF.request(url, method: .post, parameters: parameters)
            .validate()
            .publishDecodable(type: Account.self)
            .value()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }

}
