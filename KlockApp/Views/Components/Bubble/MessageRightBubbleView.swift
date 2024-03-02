//
//  MessageRightBubbleView.swift
//  KlockApp
//
//  Created by 성찬우 on 2/23/24.
//

import SwiftUI

struct MessageRightBubbleView: View {
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
        .background(FancyColor.chatBotBubbleMe.color)
        .foregroundColor(FancyColor.chatbotBubbleTextMe.color)
        .clipShape(RoundedCorners(tl: 10, tr: 0, bl: 10, br: 10))
        .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    MessageRightBubbleView(content: "안녕하세요!")
}
