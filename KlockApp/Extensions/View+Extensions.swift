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
    
    func centerInContainer() -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.clear) // 배경은 선택적으로 설정할 수 있습니다.
            .edgesIgnoringSafeArea(.all)
    }
    
    func upsideDown() -> some View {
        self
            .rotationEffect(Angle(radians: .pi))
            .scaleEffect(x: -1, y: 1, anchor: .center)
    }
}
