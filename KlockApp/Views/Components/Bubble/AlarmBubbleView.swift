//
//  AlarmBubble.swift
//  KlockApp
//
//  Created by 성찬우 on 1/4/24.
//

import SwiftUI

struct AlarmBubbleView: View {
    @Environment(\.colorScheme) var colorScheme
    var nickname: String
    var content: String
    var date: String
    var showIcon: Bool?

    var body: some View {
        HStack {
            contentStack
            Spacer()
        }
    }

    private var contentStack: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(nickname)
                .fontWeight(.semibold)
                .font(.system(size: 13))
                .foregroundColor(FancyColor.chatBotBubbleNickname.color)
                .padding(.bottom, 4)
            HStack(alignment: .bottom, spacing: 0) {
                HStack {
                    iconView
                    Text(content)
                        .bold()
                        .foregroundColor(FancyColor.text.color)
                        .padding(.leading, showIcon == true ? 0 : 14)
                        .padding(.trailing, 14)
                }
                .padding(.vertical, showIcon == true ? 0 : 14)
                .padding(.horizontal, 0)
                .background(FancyColor.bubbleAlram.color)
                .overlay(
                    RoundedCorners(tl: 0, tr: 10, bl: 10, br: 10)
                        .stroke(colorScheme == .dark ? FancyColor.gray8.color : FancyColor.gray3.color, lineWidth: 2) // 테두리 색상과 두께 지정
                )
                .clipShape(RoundedCorners(tl: 0, tr: 10, bl: 10, br: 10))
                Text(date)
                    .font(.system(size: 11))
                    .foregroundColor(FancyColor.subtext.color)
                    .padding(.leading, 8)
            }
        }
    }

    private var iconView: some View {
        Group {
            if showIcon ?? false {
                Text("🔥")
                    .padding(14)
                    .background(FancyColor.primary.color)
            }
        }
    }
}

struct AlarmBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AlarmBubbleView(nickname: "차누", content: "영어 공부를 시작했어요!", date: "", showIcon: true)
            AlarmBubbleView(nickname: "차누", content: "영어 공부를 종료했어요!", date: "", showIcon: false)
        }
    }
}
