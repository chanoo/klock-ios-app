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
    @Binding var heartCount: Int
    @Binding var scale: CGFloat

    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.scale = 3
            }
            withAnimation(.easeInOut(duration: 0.5).delay(0.5)) {
                self.scale = heartCount >= 10 ? 1.5 : 1
            }
        } label: {
            VStack(alignment: .leading) {
                if let imageURL = imageURL, imageURL.isEmpty == false {
                    MessageBubbleImageView(imageURL: imageURL, size: .infinity)
                        .padding(.bottom, content.isEmpty ? 0 : 8)
                }
                if !content.isEmpty {
                    Text(content)
                        .multilineTextAlignment(.leading)
                }
            }
        }
        .padding(12)
        .background(FancyColor.chatBotBubble.color)
        .foregroundColor(FancyColor.chatbotBubbleText.color)
        .clipShape(RoundedCorners(tl: 0, tr: 10, bl: 10, br: 10))
        .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 10))
    }
}
