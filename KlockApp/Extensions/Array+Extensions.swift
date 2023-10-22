//
//  Array+Extensions.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/07/20.
//

import Foundation

extension Array {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
