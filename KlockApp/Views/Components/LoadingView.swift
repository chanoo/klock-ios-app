//
//  LoadingView.swift
//  KlockApp
//
//  Created by 성찬우 on 11/10/23.
//

import SwiftUI

struct LoadingView: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
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
    }
}

#Preview {
    LoadingView()
}
