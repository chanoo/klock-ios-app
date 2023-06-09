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
    func signInWithApple(accessToken: String) -> AnyPublisher<AppleSignInResDTO, AFError>
    func isLoggedIn() -> Bool
}
