//
//  AccountEntity.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/28.
//

import Foundation
import CoreStore

class AccountEntity: CoreStoreObject {
    @Field.Stored("id")
    var id: Int64?
    @Field.Stored("email")
    var email: String?
    @Field.Stored("hashedPassword")
    var hashedPassword: String?
    @Field.Stored("username")
    var username: String = ""
    @Field.Stored("totalStudyTime")
    var totalStudyTime: Int = 0
    @Field.Stored("accountLevelId")
    var accountLevelId: Int64 = 0
    @Field.Stored("role")
    var roleRaw: String = "user"
    @Field.Stored("active")
    var active: Bool = true
    @Field.Stored("createdAt")
    var createdAt: Date = Date()
    @Field.Stored("updatedAt")
    var updatedAt: Date = Date()
    
    var role: AccountRole {
        get {
            return AccountRole(rawValue: roleRaw) ?? .user
        }
        set {
            roleRaw = newValue.rawValue
        }
    }
}
