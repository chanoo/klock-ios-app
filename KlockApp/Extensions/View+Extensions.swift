//
//  View+Extensions.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/10/17.
//

import SwiftUI

extension View {
    func withoutAnimation() -> some View {
        self.animation(nil, value: UUID())
    }
}
