//
//  MessageLeftBubbleView.swift
//  KlockApp
//
//  Created by 성찬우 on 2/23/24.
//

import SwiftUI

struct MessageLeftBubbleView: View {
    var content: String
    var imageURL: String?

    var body: some View {
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
        .foregroundColor(FancyColor.chatbotBubbleText.color)
        .clipShape(RoundedCorners(tl: 0, tr: 10, bl: 10, br: 10))
        .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    MessageLeftBubbleView(content: "안녕하세요!")
}
