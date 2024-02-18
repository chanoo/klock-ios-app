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
    var nickname: String
    var userTraceType: UserTraceType
    var profileImageURL: String?
    var profileImageSize: CGFloat = 44
    var content: String
    var imageURL: String?
    var date: String?

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 8) {
                if me {
                    if userTraceType == .studyStart {
                        if let date = date {
                            ProfileImageWrapperView(profileImageURL: profileImageURL)
                            AlarmBubbleView(nickname: nickname, content: content, date: date, showIcon: true)
                        }
                    } else if userTraceType == .studyEnd {
                        if let date = date {
                            ProfileImageWrapperView(profileImageURL: profileImageURL)
                            AlarmBubbleView(nickname: nickname, content: content, date: date, showIcon: false)
                        }
                    } else {
                        ProfileImageWrapperView(profileImageURL: profileImageURL)
                        VStack(alignment: .leading, spacing: 0) {
                            Text(nickname)
                                .font(.system(size: 13))
                                .foregroundColor(FancyColor.subtext.color)
                                .padding(.bottom, 4)
                            HStack(alignment: .bottom) {
                                VStack(alignment: .leading) {
                                    if let imageURL = imageURL, imageURL.isEmpty == false {
                                        MessageBubbleImageView(imageURL: imageURL, size: .infinity)
                                            .padding(.bottom, 8)
                                    }
                                    Text(content)
                                }
                                .padding(12)
                                .background(FancyColor.chatBotBubbleMe.color)
                                .clipShape(RoundedCorners(tl: 0, tr: 10, bl: 10, br: 10))
                                .foregroundColor(FancyColor.chatbotBubbleTextMe.color)
                                if let date = date {
                                    Text(date)
                                        .font(.system(size: 11))
                                        .foregroundColor(FancyColor.subtext.color)
                                }
                            }
                        }
                        Spacer()
                    }
                } else {
                    Spacer()
                    VStack(alignment: .trailing, spacing: 0) {
                        Text(nickname)
                            .font(.system(size: 13))
                            .foregroundColor(FancyColor.subtext.color)
                            .padding(.bottom, 4)
                        HStack(alignment: .bottom) {
                            if let date = date {
                                Text(date)
                                    .font(.system(size: 11))
                                    .foregroundColor(FancyColor.subtext.color)
                            }
                            VStack(alignment: .leading) {
                                if let imageURL = imageURL, imageURL.isEmpty == false {
                                    MessageBubbleImageView(imageURL: imageURL, size: .infinity)
                                        .padding(.bottom, 8)
                                }
                                Text(content)
                            }
                            .padding(12)
                            .background(FancyColor.chatBotBubble.color)
                            .clipShape(RoundedCorners(tl: 10, tr: 0, bl: 10, br: 10))
                            .foregroundColor(FancyColor.chatbotBubbleText.color)
                        }
                    }
                    if let url = profileImageURL, url.starts(with: "http") {
                        ProfileImageView(imageURL: url, size: profileImageSize)
                            .padding(.trailing, 8)
                    } else if let imageName = profileImageURL {
                        Image(imageName)
                            .cornerRadius(22.0)
                            .padding(.trailing, 8)
                    } else {
                        DefaultProfileImage(size: profileImageSize)
                    }
                }
            }
            .padding(.top, 4)
            .padding(.bottom, 4)
            .padding(.leading, me ? 8 : 16)
            .padding(.trailing, me ? 16 : 8)
        }
        .rotationEffect(.degrees(180), anchor: .center) // VStack을 180도 회전
    }
}

struct ProfileImageWrapperView: View {
    var profileImageURL: String?
    var profileImageSize: CGFloat = 44

    var body: some View {
        if let url = profileImageURL, url.starts(with: "http") {
            ProfileImageView(imageURL: url, size: profileImageSize)
                .padding(.trailing, 8)
        } else if let imageName = profileImageURL {
            Image(imageName)
                .cornerRadius(22.0)
                .padding(.trailing, 8)
        } else {
            DefaultProfileImage(size: profileImageSize)
        }
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
                        DefaultProfileImage(size: size)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .scaledToFit()
                    @unknown default:
                        DefaultProfileImage(size: size)
                    }
                }
            } else {
                DefaultProfileImage(size: size)
            }
        }
        .frame(maxWidth: size)
        .cornerRadius(6) // 모서리를 둥글게 처리
    }
}


struct MessageBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ScrollView(showsIndicators: false) { // 스크롤바 숨김
                ScrollViewReader { _ in
                    LazyVStack {
                        MessageBubbleView(me: true, nickname: "뀨쳐돌이", userTraceType: .activity, content: "영단어 교재 새로 나온 거 서점에서 구입함📚 군데 이거 열어보니까 문제들이 다 어렵기는하더라 ㅠㅜ 내가 이거 풀 수 있을까...???", date: "30초 전")
                        MessageBubbleView(me: false, nickname: "차누", userTraceType: .activity, content: "와 진짜 열심히 한다! 우리모두 열심히 하자꾸나!", date: "43초 전")
                        MessageBubbleView(me: true, nickname: "뀨쳐돌이", userTraceType: .activity, content: "영단어 교재 새로 나온 거 서점에서 구입함📚 군데 이거 열어보니까 문제들이 다 어렵기는하더라 ㅠㅜ 내가 이거 풀 수 있을까...???", imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRoXU4XsmoPnfSayFM7KDpN04SRCzkj_jT9jQ", date: "30초 전")
                        MessageBubbleView(me: false, nickname: "진우", userTraceType: .activity, content: "와 진짜 열심히 한다! 우리모두 열심히 하자꾸나!", imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKE6araToPNj5OvHYkkI7QIxhNU2qkhDMguA&usqp=CAU", date: "10시 30분 22초")
                    }
                }
            }
            .background(FancyColor.gray1.color)
            .rotationEffect(.degrees(180), anchor: .center)
        }
    }
}
