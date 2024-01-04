//
//  ChatBubble.swift
//  KlockApp
//
//  Created by 성찬우 on 1/4/24.
//

import SwiftUI

struct MessageBubble: View {
    let messageModel: MessageModel
    @Binding var isPreparingResponse: Bool

    var body: some View {
        VStack {
            HStack {
                if messageModel.isUser {
                    Spacer()
                    Text(messageModel.content)
                        .padding()
                        .background(FancyColor.chatBotBubbleMe.color)
                        .clipShape(RoundedCorners(tl: 10, tr: 10, bl: 10, br: 0))
                        .foregroundColor(FancyColor.chatbotBubbleTextMe.color)
                } else {
                    Text(messageModel.content)
                        .padding()
                        .background(FancyColor.chatBotBubble.color)
                        .clipShape(RoundedCorners(tl: 10, tr: 10, bl: 0, br: 10))
                        .foregroundColor(FancyColor.chatbotBubbleText.color)
                    Spacer()
                }
            }
            .padding(0)
            .padding(.bottom, 5)
            .padding(.leading, messageModel.isUser ? 24 : 10)
            .padding(.trailing, messageModel.isUser ? 10 : 24)
        }
        .rotationEffect(.degrees(180), anchor: .center) // VStack을 180도 회전
    }
}
