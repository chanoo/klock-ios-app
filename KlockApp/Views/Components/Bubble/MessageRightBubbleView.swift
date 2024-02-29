//
//  MessageRightBubbleView.swift
//  KlockApp
//
//  Created by 성찬우 on 2/23/24.
//

import SwiftUI

struct MessageRightBubbleView: View {
    var nickname: String
    var content: String
    var imageURL: String?
    var date: String?
    var onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            HStack(alignment: .bottom) {
                if let date = date {
                    Text(date)
                        .font(.system(size: 11))
                        .foregroundColor(FancyColor.subtext.color)
                }
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
                .clipShape(RoundedCorners(tl: 10, tr: 0, bl: 10, br: 10))
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
                        print("삭제")
                        onDelete()
                    } label: {
                        Label("삭제", image: "ic_trash")
                    }
                }
            }
        }
    }
}

#Preview {
    MessageRightBubbleView(nickname: "차누", content: "안녕하세요!", onDelete: {})
}
