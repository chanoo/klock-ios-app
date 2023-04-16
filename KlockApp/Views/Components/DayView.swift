//
//  DayView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/15.
//

// DayView.swift

import SwiftUI

struct DayView: View {
    let displayText: String?
    let size: CGFloat
    let backgroundColor: Color
    let fadeInOutDuration: TimeInterval
    let randomDelay: TimeInterval
    let maxBlinks: Int
    let buttonAction: () -> Void

    @State private var opacity: Double

    init(displayText: String? = nil, size: CGFloat, backgroundColor: Color, fadeInOutDuration: TimeInterval = 1.0, randomDelay: TimeInterval = 0.0, maxBlinks: Int = 1, buttonAction: @escaping () -> Void = {}) {
        self.displayText = displayText
        self.size = size
        self.backgroundColor = backgroundColor
        self.fadeInOutDuration = fadeInOutDuration
        self.randomDelay = randomDelay
        self.maxBlinks = maxBlinks
        self.buttonAction = buttonAction
        self.opacity = maxBlinks == 0 ? 1.0 : 0.3
    }
    
    var body: some View {
        Button(action: buttonAction) {
            ZStack {
                backgroundColor
                    .opacity(opacity)
                    .onAppear {
                        if maxBlinks > 0 {
                            withAnimation(Animation.easeInOut(duration: fadeInOutDuration).repeatCount(maxBlinks, autoreverses: true).delay(randomDelay)) {
                                opacity = 1.0
                            }
                        }
                    }

                if let text = displayText {
                    Text(text)
                }
            }
            .frame(width: size, height: size)
            .cornerRadius(5)
        }
    }
}
