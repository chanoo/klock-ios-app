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
    var nickname: String
    var content: String
    var showIcon: Bool?
    @Binding var heartCount: Int
    let onHeart: () -> Void
    @Binding var scale: CGFloat

    var body: some View {
        contentStack
    }

    private var contentStack: some View {
        ZStack(alignment: .bottomLeading) {
            Button {
                heartCount += 1
                onHeart()
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
        .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 10))
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
    var nickname: String
    var content: String
    var showIcon: Bool?
    @Binding var heartCount: Int
    let onHeart: () -> Void
    @Binding var scale: CGFloat

    var body: some View {
        contentStack
    }

    private var contentStack: some View {
        ZStack(alignment: .bottomLeading) {
            Button {
                heartCount += 1
                onHeart()
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
        .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 10))
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
//
//struct AlarmBubbleView_Previews: PreviewProvider {
//    static var previews: some View {
//        VStack {
//            AlarmLeftBubbleView(scale: .constant(1), nickname: "차누", content: "영어 공부를 시작했어요!", heartCount: .constant(3), showIcon: true)
//            AlarmRightBubbleView(scale: .constant(1), nickname: "차누", content: "영어 공부를 종료했어요!", heartCount: .constant(20), showIcon: false)
//        }
//    }
//}
