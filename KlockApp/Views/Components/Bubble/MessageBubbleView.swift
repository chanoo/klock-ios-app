//
//  ChatBubble.swift
//  KlockApp
//
//  Created by 성찬우 on 1/4/24.
//

import SwiftUI
import CachedAsyncImage

struct MessageBubbleView: View {
    var me: Bool
    var content: String
    var imageURL: String?
    var date: String?

    var body: some View {
        VStack {
            HStack {
                if me {
                    HStack(alignment: .bottom) {
                        if let date = date {
                            Text(date)
                                .font(.system(size: 14))
                                .foregroundColor(FancyColor.subtext.color)
                        }
                        VStack(alignment: .leading) {
                            if let imageURL = imageURL {
                                MessageBubbleImageView(imageURL: imageURL, size: .infinity)
                                    .padding(.bottom, 8)
                            }
                            Text(content)
                        }
                        .padding()
                        .background(FancyColor.chatBotBubbleMe.color)
                        .clipShape(RoundedCorners(tl: 10, tr: 10, bl: 10, br: 0))
                        .foregroundColor(FancyColor.chatbotBubbleTextMe.color)
                    }
                } else {
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading) {
                            if let imageURL = imageURL {
                                MessageBubbleImageView(imageURL: imageURL, size: .infinity)
                                    .padding(.bottom, 8)
                            }
                            Text(content)
                        }
                        .padding()
                        .background(FancyColor.chatBotBubble.color)
                        .clipShape(RoundedCorners(tl: 10, tr: 10, bl: 0, br: 10))
                        .foregroundColor(FancyColor.chatbotBubbleText.color)
                        if let date = date {
                            Text(date)
                                .font(.system(size: 14))
                                .foregroundColor(FancyColor.subtext.color)
                        }
                    }
                }
            }
            .padding(0)
            .padding(.bottom, 5)
            .padding(.leading, me ? 80 : 10)
            .padding(.trailing, me ? 10 : 80)
        }
        .rotationEffect(.degrees(180), anchor: .center) // VStack을 180도 회전
    }
}

struct MessageBubbleImageView: View {
    let imageURL: String?
    let size: CGFloat

    var body: some View {
        Group {
            if let urlString = imageURL, let url = URL(string: urlString) {
                CachedAsyncImage(url: url) { phase in
                    switch phase {
                    case .empty, .failure(_):
                        DefaultProfileImage()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .scaledToFit()
                    @unknown default:
                        DefaultProfileImage()
                    }
                }
            } else {
                DefaultProfileImage()
            }
        }
        .frame(maxWidth: size)
    }
}


struct MessageBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ScrollView(showsIndicators: false) { // 스크롤바 숨김
                ScrollViewReader { _ in
                    LazyVStack {
                        MessageBubbleView(me: true, content: "영단어 교재 새로 나온 거 서점에서 구입함📚 군데 이거 열어보니까 문제들이 다 어렵기는하더라 ㅠㅜ 내가 이거 풀 수 있을까...???", date: "30초 전")
                        MessageBubbleView(me: false, content: "와 진짜 열심히 한다! 우리모두 열심히 하자꾸나!", date: "43초 전")
                        MessageBubbleView(me: true, content: "영단어 교재 새로 나온 거 서점에서 구입함📚 군데 이거 열어보니까 문제들이 다 어렵기는하더라 ㅠㅜ 내가 이거 풀 수 있을까...???", imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRoXU4XsmoPnfSayFM7KDpN04SRCzkj_jT9jQ", date: "30초 전")
                        MessageBubbleView(me: false, content: "와 진짜 열심히 한다! 우리모두 열심히 하자꾸나!", imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKE6araToPNj5OvHYkkI7QIxhNU2qkhDMguA&usqp=CAU", date: "10시 30분 22초")
                    }
                }
            }
            .rotationEffect(.degrees(180), anchor: .center)
        }
    }
}
