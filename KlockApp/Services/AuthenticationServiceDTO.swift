//
//  AuthenticationServiceDTO.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/03/31.
//

import Foundation

// SignInReqDTO
struct SignInReqDTO: Encodable {
    let email: String
    let password: String
}

// FacebookSignInReqDTO
struct FacebookSignInReqDTO: Encodable {
    let accessToken: String
}

// AppleSignInReqDTO
struct AppleSignInReqDTO: Encodable {
    let accessToken: String
}
