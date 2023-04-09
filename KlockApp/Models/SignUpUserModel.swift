//
//  SignUpUserModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/08.
//

import Foundation

class SignUpUserModel: ObservableObject {
    @Published var provider: String = ""
    @Published var providerUserId: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var tagId: Int64 = 0
}
