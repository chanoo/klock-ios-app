//
//  Data+Extensions.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/08/17.
//

import Foundation

extension Data {
    subscript (safe index: Int) -> UInt8? {
        return indices.contains(index) ? self[index] : nil
    }
}
