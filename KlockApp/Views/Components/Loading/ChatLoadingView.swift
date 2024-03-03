//
//  ChatLoadingView.swift
//  KlockApp
//
//  Created by 성찬우 on 2/22/24.
//
import SwiftUI

struct ChatLoadingSkeleton: View {
    var body: some View {
        HStack(alignment: .top) {
            Circle()
                .frame(width: 44, height: 44)
                .opacity(0.3)
            VStack(alignment: .leading) {
                Rectangle()
                    .frame(width: 70, height: 11)
                    .opacity(0.3)
                    .cornerRadius(4)
                Rectangle()
                    .frame(width: 170, height: 42)
                    .opacity(0.3)
                    .cornerRadius(4)
            }
            Spacer()
        }
        .padding()
        HStack(alignment: .top) {
            Spacer()
            VStack(alignment: .trailing) {
                // 첫 번째 Rectangle 예시
                Rectangle()
                    .frame(width: 70, height: 11)
                    .opacity(0.3)
                    .cornerRadius(4)

                // 두 번째 Rectangle 예시
                Rectangle()
                    .frame(width: 170, height: 42)
                    .opacity(0.3)
                    .cornerRadius(4)
            }
        }
        .padding()
        HStack(alignment: .top) {
            Circle()
                .frame(width: 44, height: 44)
                .opacity(0.3)
            VStack(alignment: .leading) {
                Rectangle()
                    .frame(width: 70, height: 11)
                    .opacity(0.3)
                    .cornerRadius(4)
                Rectangle()
                    .frame(width: 170, height: 42)
                    .opacity(0.3)
                    .cornerRadius(4)
                Rectangle()
                    .frame(width: 200, height: 42)
                    .opacity(0.3)
                    .cornerRadius(4)
            }
            Spacer()
        }
        .padding()
        HStack(alignment: .top) {
            Spacer()
            VStack(alignment: .trailing) {
                Rectangle()
                    .frame(width: 70, height: 11)
                    .opacity(0.3)
                    .cornerRadius(4)
                Rectangle()
                    .frame(width: 170, height: 42)
                    .opacity(0.3)
                    .cornerRadius(4)
                Rectangle()
                    .frame(width: 240, height: 42)
                    .opacity(0.3)
                    .cornerRadius(4)
                Rectangle()
                    .frame(width: 200, height: 42)
                    .opacity(0.3)
                    .cornerRadius(4)
            }
        }
        .padding()
        HStack(alignment: .top) {
            Circle()
                .frame(width: 44, height: 44)
                .opacity(0.3)
            VStack(alignment: .leading) {
                // 첫 번째 Rectangle 예시
                Rectangle()
                    .frame(width: 70, height: 11)
                    .opacity(0.3)
                    .cornerRadius(4)
                Rectangle()
                    .frame(width: 170, height: 42)
                    .opacity(0.3)
                    .cornerRadius(4)
                Rectangle()
                    .frame(width: 120, height: 42)
                    .opacity(0.3)
                    .cornerRadius(4)
                Rectangle()
                    .frame(width: 200, height: 42)
                    .opacity(0.3)
                    .cornerRadius(4)
            }
            Spacer()
        }
        .padding()
        HStack(alignment: .top) {
            Spacer()
            VStack(alignment: .trailing) {
                // 첫 번째 Rectangle 예시
                Rectangle()
                    .frame(width: 70, height: 11)
                    .opacity(0.3)
                    .cornerRadius(4)
                // 두 번째 Rectangle 예시
                Rectangle()
                    .frame(width: 240, height: 42)
                    .opacity(0.3)
                    .cornerRadius(4)
                Rectangle()
                    .frame(width: 170, height: 42)
                    .opacity(0.3)
                    .cornerRadius(4)
            }
        }
        .padding()

    }
}

struct ChatLoadingView: View {
//    @State private var gradientX: CGFloat = -1 // 그라디언트의 초기 위치

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ChatLoadingSkeleton()
                Spacer()
            }
        }
        .disabled(true) // 스크롤
        .background(LinearGradientBackground().opacity(0.8)) // 전체 배경에 그라디언트 적용
        .mask(
            ScrollView {
                VStack(spacing: 0) {
                    ChatLoadingSkeleton()
                    Spacer()
                }
            }
            .disabled(true) // 스크롤
        )
//        .onAppear {
//            withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
//                gradientX = 0 // 애니메이션을 시작하여 그라디언트를 움직임
//            }
//        }
    }
}

struct LinearGradientBackground: View {
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

struct ChatLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        ChatLoadingView()
    }
}
