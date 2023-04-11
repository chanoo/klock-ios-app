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
                tagId: Int64?) -> AnyPublisher<SignUpResDTO, AFError> {
        let url = "\(baseURL)/signup"
        let requestDTO = SignUpReqDTO(username: username, provider: provider, providerUserId: providerUserId, tagId: tagId)
        
        return AF.request(url, method: .post, parameters: requestDTO.dictionary, encoding: JSONEncoding.default)
            .validate()
            .publishDecodable(type: SignUpResDTO.self)
            .tryMap { result -> SignUpResDTO in
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
            .mapError { $0 as! AFError }
            .eraseToAnyPublisher()
    }

    func signInWithFacebook(accessToken: String) -> AnyPublisher<AccountModel, AFError> {
        let url = "\(baseURL)/signin-with-facebook"
        let requestDTO = FacebookSignInReqDTO(accessToken: accessToken)

        return requestAndDecode(url: url, parameters: requestDTO.dictionary)
    }

    func signInWithApple(accessToken: String) -> AnyPublisher<AppleSignInResDTO, AFError> {
        let url = "\(baseURL)/signin-with-apple"
        let requestDTO = AppleSignInReqDTO(accessToken: accessToken)

        return AF.request(url, method: .post, parameters: requestDTO.dictionary, encoding: JSONEncoding.default)
            .validate()
            .publishDecodable(type: AppleSignInResDTO.self)
            .tryMap { result -> AppleSignInResDTO in
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
            .mapError { $0 as! AFError }
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
    
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.string(forKey: "userToken") != nil
    }
}
