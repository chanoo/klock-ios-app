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
    let speed: CGFloat?
    let currentFrame: CGFloat?

    init(name: String, speed: CGFloat? = 0.7, currentFrame: CGFloat? = 0) {
        self.name = name
        self.speed = speed
        self.currentFrame = currentFrame
    }

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> LottieAnimationView {
        let animationView = LottieAnimationView(name: name)
        animationView.loopMode = .loop
        animationView.animationSpeed = speed ?? 1.0
        animationView.currentFrame = currentFrame ?? 0
        animationView.play()
        return animationView
    }

    func updateUIView(_ uiView: LottieAnimationView, context: UIViewRepresentableContext<LottieView>) {
    }
}
