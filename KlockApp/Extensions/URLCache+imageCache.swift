//
//  URLCache+imageCache.swift
//  KlockApp
//
//  Created by 성찬우 on 2/21/24.
//

import Foundation

extension URLCache {
    static let imageCache = URLCache(memoryCapacity: 512_000_000, diskCapacity: 10_000_000_000)
}
