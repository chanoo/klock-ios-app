//
//  AuthenticationServiceDTO.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/03/31.
//

import Foundation

struct SignUpReqDTO: Encodable {
    let nickname: String
    let provider: String
    let providerUserId: String
    let tagId: Int64?
    let startOfTheWeek: String
    let startOfTheDay: Int
}

struct SignUpResDTO: Decodable {
    let id: Int64
    let accessToken: String
    let refreshToken: String
    let nickname: String
    let provider: String
    let providerUserId: String
    let email: String?
    let tagId: Int64
    let startOfTheWeek: String
    let startOfTheDay: Int
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

struct SocialLoginReqDTO: Encodable {
    let provider: String
    let providerUserId: String
}

struct SocialLoginResDTO: Decodable {
    let token: String
    let userId: Int64
    let publicKey: String
}
