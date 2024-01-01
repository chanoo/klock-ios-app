//
//  RSACrypto.swift
//  KlockApp
//
//  Created by 성찬우 on 1/1/24.
//

import CryptoKit
import Foundation
import Security

class RSACrypto {
    static func publicKey(from base64EncodedPublicKey: String) -> SecKey? {
        guard let keyData = Data(base64Encoded: base64EncodedPublicKey) else {
            print("Base64 Decoding Failed")
            return nil
        }

        let keyDictionary: [CFString: Any] = [
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass: kSecAttrKeyClassPublic
        ]

        guard let publicKey = SecKeyCreateWithData(keyData as CFData, keyDictionary as CFDictionary, nil) else {
            print("SecKey Creation Failed")
            return nil
        }

        return publicKey
    }

    static func encryptData(_ data: Data, using publicKey: SecKey) -> Data? {
        var error: Unmanaged<CFError>?
        guard let encryptedData = SecKeyCreateEncryptedData(publicKey, .rsaEncryptionOAEPSHA256, data as CFData, &error) as Data? else {
            print("RSA Encryption Error: \(error!.takeRetainedValue() as Error)")
            return nil
        }

        return encryptedData
    }
}
