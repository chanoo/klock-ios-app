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
    func signIn(email: String, password: String) -> AnyPublisher<AccountModel, AFError> {
        let url = "\(baseURL)/signin"
        let requestDTO = SignInReqDTO(email: email, password: password)

        return requestAndDecode(url: url, parameters: requestDTO.dictionary)
    }
    
    func signUp(username: String,
                provider: String,
                providerUserId: String,
                tagId: Int64?) -> AnyPublisher<AccountModel, AFError> {
        let url = "\(baseURL)/signup"
        let requestDTO = SignUpReqDTO(username: username, provider: provider, providerUserId: providerUserId, tagId: tagId)

        return requestAndDecode(url: url, parameters: requestDTO.dictionary)
    }

    func signInWithFacebook(accessToken: String) -> AnyPublisher<AccountModel, AFError> {
        let url = "\(baseURL)/signin-with-facebook"
        let requestDTO = FacebookSignInReqDTO(accessToken: accessToken)

        return requestAndDecode(url: url, parameters: requestDTO.dictionary)
    }

    func signInWithApple(accessToken: String) -> AnyPublisher<AccountModel, AFError> {
        let url = "\(baseURL)/signin-with-apple"
        let requestDTO = AppleSignInReqDTO(accessToken: accessToken)

        return requestAndDecode(url: url, parameters: requestDTO.dictionary)
            .mapError { error in
                if error.responseCode == 401 {
                    return AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 401))
                } else {
                    return error
                }
            }
            .eraseToAnyPublisher()
    }

    private func requestAndDecode(url: String, parameters: [String: Any]) -> AnyPublisher<AccountModel, AFError> {
        return AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .publishDecodable(type: AccountModel.self)
            .value()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}
