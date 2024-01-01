//
//  AESCrypto.swift
//  KlockApp
//
//  Created by 성찬우 on 1/1/24.
//

import CryptoKit
import Foundation
import Security

class AESCrypto {
    static func encryptString(_ string: String, using key: SymmetricKey) -> Data? {
        guard let data = string.data(using: .utf8) else { return nil }
        do {
            let sealedBox = try AES.GCM.seal(data, using: key)
            return sealedBox.combined
        } catch {
            print("AES Encryption Error: \(error)")
            return nil
        }
    }
}
