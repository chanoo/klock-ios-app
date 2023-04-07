//
//  AuthenticationServiceDTO.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/03/31.
//

import Foundation

struct SignUpReqDTO: Encodable {
    let username: String
    let provider: String
    let providerUserId: String
    let tagId: Int64?
}

struct SignUpResDTO: Encodable {
    let id: Int64
    let username: String
    let provider: String
    let providerUserId: String
    let tagId: Int64?
}

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
