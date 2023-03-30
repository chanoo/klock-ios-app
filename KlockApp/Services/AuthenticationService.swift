//
//  AuthenticationService.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/03/30.
//

import Foundation
import Alamofire
import Combine

class AuthenticationService {
    private let baseURL = "https://api.klock.app/api/auth"

    func signIn(email: String, password: String) -> AnyPublisher<User, Error> {
        let url = "\(baseURL)/signin"
        let parameters: [String: Any] = ["email": email, "password": password]

        return Alamofire.request(url, method: .post, parameters: parameters)
            .validate()
            .publishDecodable(type: User.self)
            .value()
    }

    // 회원 가입 함수를 여기에 작성하세요.
}
