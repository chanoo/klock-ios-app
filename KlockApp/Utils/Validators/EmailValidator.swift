//
//  EmailValidator.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/03/30.
//

import Foundation

struct EmailValidator {
    private let emailPattern = RegexConstants.emailPattern
    private let emailPredicate: NSPredicate

    init() {
        emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailPattern)
    }

    func isValid(_ email: String) -> Bool {
        return emailPredicate.evaluate(with: email)
    }
}
