//
//  ClearListBackground+Extensions.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/27.
//

import Foundation
import SwiftUI

struct ClearListBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.scrollContentBackground(.hidden)
        } else {
            content
        }
    }
}

extension View {
    func clearListBackground() -> some View {
        modifier(ClearListBackgroundModifier())
    }
}
