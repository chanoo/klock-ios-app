//
//  MessageLeftBubbleView.swift
//  KlockApp
//
//  Created by 성찬우 on 2/23/24.
//

import SwiftUI

struct MessageLeftBubbleView: View {
    var nickname: String
    var content: String
    var imageURL: String?
    var date: String?
    var onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(nickname)
                .fontWeight(.semibold)
                .font(.system(size: 13))
                .foregroundColor(FancyColor.chatBotBubbleNickname.color)
                .padding(.bottom, 4)
            HStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    if let imageURL = imageURL, imageURL.isEmpty == false {
                        MessageBubbleImageView(imageURL: imageURL, size: .infinity)
                            .padding(.bottom, content.isEmpty ? 0 : 8)
                    }
                    if !content.isEmpty {
                        Text(content)
                    }
                }
                .padding(12)
                .background(FancyColor.chatBotBubble.color)
                .clipShape(RoundedCorners(tl: 0, tr: 10, bl: 10, br: 10))
                .foregroundColor(FancyColor.chatbotBubbleText.color)
                .contextMenu { // Use contextMenu instead of onLongPressGesture
                    Button(action: {
                        UIPasteboard.general.string = content // `content`의 값을 클립보드에 복사
                        print("복사됨: \(content)")
                    }) {
                        Label("복사", image: "ic_documents")
                    }
                    Button(role: .destructive) { // 👈 This argument
                        // delete something
                        print("신고")
                    } label: {
                        Label("신고", image: "ic_emergency")
                    }
                }

                if let date = date {
                    Text(date)
                        .font(.system(size: 11))
                        .foregroundColor(FancyColor.subtext.color)
                }
            }
        }
    }
}

#Preview {
    MessageLeftBubbleView(nickname: "차누", content: "안녕하세요!", onDelete: {})
}
