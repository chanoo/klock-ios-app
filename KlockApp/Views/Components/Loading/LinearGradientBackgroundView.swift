//
//  LinearGradientBackgroundView.swift
//  KlockApp
//
//  Created by 성찬우 on 3/10/24.
//

import SwiftUI

struct LinearGradientBackgroundView: View {
    @State private var isAnimating = false
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.clear, Color.clear, Color.clear, Color.gray.opacity(0.6), Color.clear, Color.clear, Color.clear]), startPoint: .leading, endPoint: .trailing)
            .rotationEffect(.degrees(0))
            .offset(x: isAnimating ? UIScreen.main.bounds.width : -UIScreen.main.bounds.width)
            .animation(Animation.linear(duration: 0.8).repeatForever(autoreverses: false), value: isAnimating)
            .onAppear {
                isAnimating = true
            }
    }
}

#Preview {
    LinearGradientBackgroundView()
}
