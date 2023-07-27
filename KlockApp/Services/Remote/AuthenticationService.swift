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
    private let baseURL = "https://api.klock.app/api/v1/auth"

    func signUp(nickname: String,
                provider: String,
                providerUserId: String,
                tagId: Int64?,
                startOfTheWeek: FirstDayOfWeek,
                startOfTheDay: Int
    ) -> AnyPublisher<SignUpResDTO, AFError> {
        let url = "\(baseURL)/signup"
        let requestDTO = SignUpReqDTO(nickname: nickname, provider: provider, providerUserId: providerUserId, tagId: tagId, startOfTheWeek: startOfTheWeek.rawValue, startOfTheDay: startOfTheDay)

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

    func signInWithFacebook(accessToken: String) -> AnyPublisher<UserModel, AFError> {
        let url = "\(baseURL)/signin-with-facebook"
        let requestDTO = FacebookSignInReqDTO(accessToken: accessToken)

        return requestAndDecode(url: url, parameters: requestDTO.dictionary)
    }
    
    func socialLogin(provider: String, providerUserId: String) -> AnyPublisher<SocialLoginResDTO, Alamofire.AFError> {
        let url = "\(baseURL)/social-login"
        let requestDTO = SocialLoginReqDTO(provider: provider, providerUserId: providerUserId)

        return AF.request(url, method: .post, parameters: requestDTO.dictionary, encoding: JSONEncoding.default)
            .validate()
            .publishDecodable(type: SocialLoginResDTO.self)
            .tryMap { result -> SocialLoginResDTO in
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

    func signInWithApple(accessToken: String) -> AnyPublisher<SocialLoginResDTO, AFError> {
        let url = "\(baseURL)/signin-with-apple"
        let requestDTO = AppleSignInReqDTO(accessToken: accessToken)

        return AF.request(url, method: .post, parameters: requestDTO.dictionary, encoding: JSONEncoding.default)
            .validate()
            .publishDecodable(type: SocialLoginResDTO.self)
            .tryMap { result -> SocialLoginResDTO in
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

    private func requestAndDecode(url: String, parameters: [String: Any]) -> AnyPublisher<UserModel, AFError> {
        return AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .publishDecodable(type: UserModel.self)
            .value()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }

    func isLoggedIn() -> Bool {
        return UserDefaults.standard.string(forKey: "access.token") != nil
    }
}
