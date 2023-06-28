//
//  SlideUpTransition.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/06/28.
//

import Foundation
import SwiftUI

struct SlideUpTransition: ViewModifier {
    let isPresented: Bool

    func body(content: Content) -> some View {
        content
            .transition(.move(edge: .bottom))
            .offset(y: isPresented ? 0 : UIScreen.main.bounds.height)
    }
}
