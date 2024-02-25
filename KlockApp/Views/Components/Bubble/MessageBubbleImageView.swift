//
//  MessageBubbleImageView.swift
//  KlockApp
//
//  Created by 성찬우 on 2/25/24.
//

import SwiftUI
import CachedAsyncImage

struct MessageBubbleImageView: View {
    let imageURL: String?
    let size: CGFloat

    var body: some View {
        Group {
            if let urlString = imageURL, let url = URL(string: urlString) {
                CachedAsyncImage(url: url, urlCache: .imageCache) { phase in
                    switch phase {
                    case .empty, .failure(_):
                        DefaultMessageBubbleImageView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    @unknown default:
                        DefaultMessageBubbleImageView()
                    }
                }
            } else {
                DefaultMessageBubbleImageView()
            }
        }
        .frame(maxWidth: size)
        .cornerRadius(6) // 모서리를 둥글게 처리
    }
}

struct DefaultMessageBubbleImageView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Image("img_image_placeholder")
                Spacer()
            }
            .frame(width: .infinity, height: .infinity)
            Spacer()
        }
        .background(FancyColor.imagePlaceholder.color)
        .aspectRatio(1, contentMode: .fit) // 너비에 맞춰 높이 조절
        .frame(width: .infinity, height: .infinity)
    }
}
