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
    let onDelete: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            if me {
                if userTraceType == .studyStart {
                    if let date = date {
                        ProfileImageWrapperView(profileImageURL: profileImageURL)
                            .padding(.trailing, 8)
                        AlarmBubbleView(nickname: nickname, content: content, date: date, showIcon: true)
                    }
                } else if userTraceType == .studyEnd {
                    if let date = date {
                        ProfileImageWrapperView(profileImageURL: profileImageURL)
                            .padding(.trailing, 8)
                        AlarmBubbleView(nickname: nickname, content: content, date: date, showIcon: false)
                    }
                } else {
                    ProfileImageWrapperView(profileImageURL: profileImageURL)
                        .padding(.trailing, 8)
                    MessageLeftBubbleView(nickname: nickname, content: content, imageURL: imageURL, date: date) {
                        onDelete()
                    }
                }
            } else {
                MessageRightBubbleView(nickname: nickname, content: content, imageURL: imageURL, date: date) {
                    onDelete()
                }
                ProfileImageWrapperView(profileImageURL: profileImageURL)
                    .padding(.leading, 8)
            }
        }
        .padding(.top, 4)
        .padding(.bottom, 4)
        .padding(.leading, me ? 8 : 16)
        .padding(.trailing, me ? 16 : 8)
    }
}

struct MessageBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ScrollView(showsIndicators: false) { // 스크롤바 숨김
                ScrollViewReader { _ in
                    LazyVStack {
                        MessageBubbleView(me: true, nickname: "뀨쳐돌이", userTraceType: .activity, content: "영단어 교재 새로 나온 거 서점에서 구입함📚 군데 이거 열어보니까 문제들이 다 어렵기는하더라 ㅠㅜ 내가 이거 풀 수 있을까...???", date: "30초 전", onDelete: {})
                        MessageBubbleView(me: false, nickname: "차누", userTraceType: .activity, content: "와 진짜 열심히 한다! 우리모두 열심히 하자꾸나!", date: "43초 전", onDelete: {})
                        MessageBubbleView(me: true, nickname: "뀨쳐돌이", userTraceType: .activity, content: "영단어 교재 새로 나온 거 서점에서 구입함📚 군데 이거 열어보니까 문제들이 다 어렵기는하더라 ㅠㅜ 내가 이거 풀 수 있을까...???", imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRoXU4XsmoPnfSayFM7KDpN04SRCzkj_jT9jQ", date: "30초 전", onDelete: {})
                        MessageBubbleView(me: false, nickname: "진우", userTraceType: .activity, content: "와 진짜 열심히 한다! 우리모두 열심히 하자꾸나!", imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKE6araToPNj5OvHYkkI7QIxhNU2qkhDMguA&usqp=CAU", date: "10시 30분 22초", onDelete: {})
                    }
                }
            }
            .background(FancyColor.gray1.color)
            .rotationEffect(.degrees(180), anchor: .center)
        }
    }
}
