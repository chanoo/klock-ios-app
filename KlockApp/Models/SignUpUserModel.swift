//
//  SignUpUserModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/08.
//

import Foundation

enum FirstDayOfWeek: String, Codable {
    case sunday = "SUNDAY"
    case monday = "MONDAY"
}

class SignUpUserModel: ObservableObject {
    @Published var provider: String = ""
    @Published var providerUserId: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var nickname: String = ""
    @Published var startDay: FirstDayOfWeek = .sunday
    @Published var startTime: Int = 5
    @Published var email: String = ""
    @Published var tagId: Int64 = 0
}
