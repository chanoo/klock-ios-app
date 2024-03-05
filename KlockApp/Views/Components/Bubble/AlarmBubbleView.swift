//
//  AlarmBubble.swift
//  KlockApp
//
//  Created by 성찬우 on 1/4/24.
//

import SwiftUI
import Combine

struct AlarmLeftBubbleView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var scale: CGFloat = 1

    var nickname: String
    var content: String
    @Binding var heartCount: Int
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
                ZStack(alignment: .bottomTrailing) {
                    ZStack(alignment: .bottomLeading) {
                        Button {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                self.scale = 2
                            }
                            withAnimation(.easeInOut(duration: 0.5).delay(0.5)) {
                                self.scale = heartCount >= 10 ? 1.5 : 1
                            }
                        } label: {
                            HStack {
                                iconView
                                Text(content)
                                    .bold()
                                    .foregroundColor(FancyColor.text.color)
                                    .padding(.leading, showIcon == true ? 0 : 14)
                                    .padding(.trailing, 14)
                            }
                        }
                    }
                    .padding(.vertical, showIcon == true ? 0 : 14)
                    .padding(.horizontal, 0)
                    .background(FancyColor.bubbleAlram.color)
                    .overlay(
                        RoundedCorners(tl: 0, tr: 10, bl: 10, br: 10)
                            .stroke(colorScheme == .dark ? FancyColor.gray8.color : FancyColor.gray3.color, lineWidth: 2) // 테두리 색상과 두께 지정
                    )
                    .clipShape(RoundedCorners(tl: 0, tr: 10, bl: 10, br: 10))
                    Image("ic_love")
                        .foregroundColor(FancyColor.red.color)
                        .padding(.bottom, -8)
                        .padding(.trailing, -8)
                        .scaleEffect(scale)
                        .zIndex(10)

                }
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


struct AlarmRightBubbleView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var scale: CGFloat = 1

    var nickname: String
    var content: String
    @Binding var heartCount: Int
    var date: String
    var showIcon: Bool?

    var body: some View {
        HStack {
            Spacer()
            contentStack
        }
    }

    private var contentStack: some View {
        HStack(alignment: .bottom, spacing: 0) {
            Text(date)
                .font(.system(size: 11))
                .foregroundColor(FancyColor.subtext.color)
                .padding(.trailing, 8)
            ZStack(alignment: .bottomLeading) {
                Image("ic_love")
                    .foregroundColor(FancyColor.red.color)
                    .padding(.bottom, -8)
                    .padding(.leading, -8)
                    .scaleEffect(scale)
                    .zIndex(10)
                ZStack(alignment: .bottomLeading) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            self.scale = 3
                        }
                        withAnimation(.easeInOut(duration: 0.5).delay(0.5)) {
                            self.scale = heartCount >= 10 ? 1.5 : 1
                        }
                    } label: {
                        HStack(alignment: .center, spacing: 0) {
                            Text(content)
                                .bold()
                                .foregroundColor(FancyColor.text.color)
                                .padding(.trailing, showIcon == true ? 8 : 14)
                                .padding(.leading, 14)
                            iconView
                        }
                    }
                }
                .padding(.vertical, showIcon == true ? 0 : 14)
                .padding(.horizontal, 0)
                .background(FancyColor.bubbleAlram.color)
                .overlay(
                    RoundedCorners(tl: 10, tr: 0, bl: 10, br: 10)
                        .stroke(colorScheme == .dark ? FancyColor.gray8.color : FancyColor.gray3.color, lineWidth: 2) // 테두리 색상과 두께 지정
                )
                .clipShape(RoundedCorners(tl: 10, tr: 0, bl: 10, br: 10))
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
            AlarmLeftBubbleView(nickname: "차누", content: "영어 공부를 시작했어요!", heartCount: .constant(3), date: "", showIcon: true)
            AlarmRightBubbleView(nickname: "차누", content: "영어 공부를 종료했어요!", heartCount: .constant(20), date: "", showIcon: false)
        }
    }
}
