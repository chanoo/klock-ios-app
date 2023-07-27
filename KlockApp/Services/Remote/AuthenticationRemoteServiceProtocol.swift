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
    func signUp(nickname: String, provider: String, providerUserId: String, tagId: Int64?, startOfTheWeek: FirstDayOfWeek, startOfTheDay: Int) -> AnyPublisher<SignUpResDTO, AFError>
    func signInWithFacebook(accessToken: String) -> AnyPublisher<UserModel, AFError>
    func signInWithApple(accessToken: String) -> AnyPublisher<SocialLoginResDTO, AFError>
    func socialLogin(provider: String, providerUserId: String) -> AnyPublisher<SocialLoginResDTO, AFError>
    func isLoggedIn() -> Bool
}
