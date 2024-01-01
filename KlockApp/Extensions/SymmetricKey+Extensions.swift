//
//  SymmetricKey+Extensions.swift
//  KlockApp
//
//  Created by 성찬우 on 12/31/23.
//

import Foundation
import CryptoKit

extension SymmetricKey {
    func toData() -> Data {
        return withUnsafeBytes {
            Data($0)
        }
    }
}
