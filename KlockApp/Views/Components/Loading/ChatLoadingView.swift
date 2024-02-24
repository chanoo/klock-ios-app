//
//  ChatLoadingView.swift
//  KlockApp
//
//  Created by 성찬우 on 2/22/24.
//

import SwiftUI

struct ChatLoadingView: View {
    let gradient = LinearGradient(gradient: Gradient(colors: [Color.clear, Color.white.opacity(0.4), Color.clear]), startPoint: .leading, endPoint: .trailing)
    
    // 그라데이션 이동을 위한 state 변수
    @State private var gradientOffset = CGFloat(-0.5)

    var body: some View {
        VStack(spacing: 0) {
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        // 첫 번째 Rectangle 예시
                        Rectangle()
                            .fill(Color(red: 0.87, green: 0.88, blue: 0.9))
                            .frame(width: 70, height: 11)
                            .cornerRadius(4)
                            .overlay(
                                gradient
                                    .mask(Rectangle().cornerRadius(4))
                                    .offset(x: gradientOffset) // Rectangle의 너비에 따라 offset 조정
                            )

                        // 두 번째 Rectangle 예시
                        Rectangle()
                            .fill(Color(red: 0.87, green: 0.88, blue: 0.9))
                            .frame(width: 170, height: 42)
                            .cornerRadius(4)
                            .overlay(
                                gradient
                                    .mask(Rectangle().cornerRadius(4))
                                    .offset(x: gradientOffset) // Rectangle의 너비에 따라 offset 조정
                            )
                    }
                    Spacer()
                }
                .padding()
            }
            Spacer()
        }
        .onAppear {
            withAnimation(Animation.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                self.gradientOffset = 1.5 // 이 값을 조정하여 그라데이션 이동 범위 변경
            }
        }
    }
}

#Preview {
    ChatLoadingView()
}
