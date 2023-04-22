//
//  LottieView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/22.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let name: String

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> LottieAnimationView {
        let animationView = LottieAnimationView(name: name)
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.7
        animationView.play()
        return animationView
    }

    func updateUIView(_ uiView: LottieAnimationView, context: UIViewRepresentableContext<LottieView>) {
    }
}
