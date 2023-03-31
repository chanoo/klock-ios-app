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
        let requestDTO = SignInReqDTO(email: email, password: password)

        return requestAndDecode(url: url, parameters: requestDTO.dictionary)
    }

    func signInWithFacebook(accessToken: String) -> AnyPublisher<Account, AFError> {
        let url = "\(baseURL)/signin-with-facebook"
        let requestDTO = FacebookSignInReqDTO(accessToken: accessToken)

        return requestAndDecode(url: url, parameters: requestDTO.dictionary)
    }
    
    func signInWithApple(accessToken: String) -> AnyPublisher<Account, AFError> {
        let url = "\(baseURL)/signin-with-apple"
        let requestDTO = AppleSignInReqDTO(accessToken: accessToken)

        return requestAndDecode(url: url, parameters: requestDTO.dictionary)
    }
    
    private func requestAndDecode(url: String, parameters: [String: Any]) -> AnyPublisher<Account, AFError> {
        return AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .publishDecodable(type: Account.self)
        
        
            .value()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}
