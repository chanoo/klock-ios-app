//
//  ChatBubble.swift
//  KlockApp
//
//  Created by 성찬우 on 1/4/24.
//

import SwiftUI

struct MessageBubbleView: View {
    @EnvironmentObject var actionSheetManager: ActionSheetManager
    
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
                Spacer()
                if userTraceType == .studyStart {
                    if let date = date {
                        AlarmRightBubbleView(nickname: nickname, content: content, heartCount: .constant(10), date: date, showIcon: true)
                    }
                } else if userTraceType == .studyEnd {
                    if let date = date {
                        AlarmRightBubbleView(nickname: nickname, content: content, heartCount: .constant(23), date: date, showIcon: false)
                    }
                } else {
                    VStack(alignment: .trailing, spacing: 0) {
                        HStack(alignment: .bottom) {
                            if let date = date {
                                Text(date)
                                    .font(.system(size: 11))
                                    .foregroundColor(FancyColor.subtext.color)
                            }
                            MessageRightBubbleView(content: content, imageURL: imageURL)
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
            } else {
                if userTraceType == .studyStart {
                    ProfileImageWrapperView(profileImageURL: profileImageURL)
                        .padding(.trailing, 8)
                    if let date = date {
                        AlarmLeftBubbleView(nickname: nickname, content: content, heartCount: .constant(10), date: date, showIcon: true)
                    }
                } else if userTraceType == .studyEnd {
                    ProfileImageWrapperView(profileImageURL: profileImageURL)
                        .padding(.trailing, 8)
                    if let date = date {
                        AlarmLeftBubbleView(nickname: nickname, content: content, heartCount: .constant(10), date: date, showIcon: false)
                    }
                } else {
                    ProfileImageWrapperView(profileImageURL: profileImageURL)
                        .padding(.trailing, 8)
                    VStack(alignment: .leading, spacing: 0) {
                        Text(nickname)
                            .fontWeight(.semibold)
                            .font(.system(size: 13))
                            .foregroundColor(FancyColor.chatBotBubbleNickname.color)
                            .padding(.bottom, 4)
                        HStack(alignment: .bottom) {
                            MessageLeftBubbleView(content: content, imageURL: imageURL)
                                .contextMenu { // Use contextMenu instead of onLongPressGesture
                                    Button(action: {
                                        UIPasteboard.general.string = content // `content`의 값을 클립보드에 복사
                                        print("복사됨: \(content)")
                                    }) {
                                        Label("복사", image: "ic_documents")
                                    }
                                    Button(role: .destructive) { // 👈 This argument
                                        @State var disableButton: Bool?
                                        var selectedIssue: String?
                                        let flagOnIssueContentView = FlagOnIssueContentView(onIssueSelected: { issue in
                                            print("issue \(issue)")
                                            disableButton = true
                                            selectedIssue = issue
                                        })
                                        actionSheetManager.actionSheet = CustomActionSheetView(
                                            title: "사용자 신고하기",
                                            message: "사용자를 신고하는 이유를 선택해주세요.",
                                            content: AnyView(
                                                flagOnIssueContentView
                                                    .environmentObject(actionSheetManager)
                                            ),
                                            actionButtons: nil,
                                            cancelButton: FancyButton(title: "취소", action: {
                                                print("selectedIssue \(selectedIssue ?? "-")")
                                                withAnimation(.spring()) {
                                                    actionSheetManager.isPresented = false
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                        actionSheetManager.actionSheet = nil
                                                    }
                                                }
                                            }, style: .constant(.text))
                                        )
                                        withAnimation(.spring()) {
                                            actionSheetManager.isPresented = true
                                        }

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
                Spacer()
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
