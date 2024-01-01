//
//  String+Extensions.swift
//  KlockApp
//
//  Created by 성찬우 on 12/31/23.
//

import Foundation

extension String {
    // Base64 인코딩
    func base64Encoded() -> String? {
        guard let data = self.data(using: .utf8) else { return nil }
        return data.base64EncodedString()
    }

    // Base64 디코딩
    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
