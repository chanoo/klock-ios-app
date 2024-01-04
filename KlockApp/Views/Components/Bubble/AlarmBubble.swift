//
//  AlarmBubble.swift
//  KlockApp
//
//  Created by 성찬우 on 1/4/24.
//

import SwiftUI

struct AlarmBubble: View {
    @Environment(\.colorScheme) var colorScheme
    var content: String
    var showIcon: Bool?

    var body: some View {
        HStack {
            contentStack
            Spacer()
        }
        .padding(.bottom, 5)
        .padding(.leading, 24)
    }

    private var contentStack: some View {
        HStack {
            iconView
            Text(content)
                .bold()
                .foregroundColor(FancyColor.text.color)
                .padding(.leading, 8)
                .padding(.trailing, 14)
        }
        .padding(.vertical, showIcon == true ? 0 : 16)
        .padding(.horizontal, showIcon == true ? 0 : 8)
        .background(FancyColor.bubbleAlram.color)
        .overlay(
            RoundedCorners(tl: 10, tr: 10, bl: 0, br: 10)
                .stroke(colorScheme == .dark ? FancyColor.gray8.color : FancyColor.gray3.color, lineWidth: 2) // 테두리 색상과 두께 지정
        )
        .clipShape(RoundedCorners(tl: 10, tr: 10, bl: 0, br: 10)) // 모서리를 둥글게 자르기
    }

    private var iconView: some View {
        Group {
            if showIcon ?? false {
                Text("🔥")
                    .padding()
                    .background(FancyColor.primary.color)
            }
        }
    }
}

struct AlarmBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AlarmBubble(content: "영어 공부를 시작했어요!", showIcon: true)
            AlarmBubble(content: "영어 공부를 종료했어요!", showIcon: false)
        }
    }
}
