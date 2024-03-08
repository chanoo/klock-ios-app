//
//  TimerLoadingView.swift
//  KlockApp
//
//  Created by 성찬우 on 3/10/24.
//

import SwiftUI

struct TimerLoadingSkeleton: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Circle()
                .frame(width: 260, height: 260)
                .opacity(0.3)
                .padding(.top, 40)
            Spacer()
            VStack(alignment: .center) {
                Rectangle()
                    .frame(width: 120, height: 20)
                    .opacity(0.3)
                    .cornerRadius(4)
                Rectangle()
                    .frame(width: 210, height: 40)
                    .opacity(0.3)
                    .cornerRadius(4)
                Rectangle()
                    .frame(width: 140, height: 52)
                    .opacity(0.3)
                    .cornerRadius(4)
                    .padding(.top, 30)
            }
            .padding(.top, 30)
            Spacer()
        }
    }
}

struct TimerLoadingView: View {
    var body: some View {
        TimerLoadingSkeleton()
        .disabled(true) // 스크롤
        .background(LinearGradientBackgroundView().opacity(0.8)) // 전체 배경에 그라디언트 적용
        .mask(
            TimerLoadingSkeleton()
            .disabled(true) // 스크롤
        )
    }
}


#Preview {
    TimerLoadingView()
}
