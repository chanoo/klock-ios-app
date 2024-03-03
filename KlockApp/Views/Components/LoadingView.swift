//
//  LoadingView.swift
//  KlockApp
//
//  Created by 성찬우 on 11/10/23.
//

import SwiftUI

struct LoadingView: View {
    var opacity: Double?
    @Environment(\.colorScheme) var colorScheme
    
    init(opacity: Double? = 1.0) {
        self.opacity = opacity
    }

    var body: some View {
        ZStack {
            
            FancyColor.background.color
                .opacity(opacity ?? 1.0)
                .edgesIgnoringSafeArea(.all) // 전체 화면에 배경색 적용
            
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    ZStack(alignment: .center) {
                        if colorScheme == .dark {
                            LottieView(name: "lottie-loading-white", speed: 1.1)
                                .frame(width: 120, height: 120)
                        } else {
                            LottieView(name: "lottie-loading-black", speed: 1.1)
                                .frame(width: 120, height: 120)
                        }
                    }
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

#Preview {
    LoadingView()
}
