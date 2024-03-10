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
    @Binding var heartCount: Int
    let onDelete: () -> Void
    @State private var scale: CGFloat = 1
    
    var heartRightView: some View {
        Group {
            if heartCount > 0 {
                Image("ic_love")
                    .foregroundColor(FancyColor.red.color)
                    .padding(.bottom, -8)
                    .padding(.leading, -8)
                    .scaleEffect(scale)
                    .zIndex(10)
            }
        }
    }
    
    var dateRightView: some View {
        Group {
            if let date = date {
                Text(date)
                    .font(.system(size: 11))
                    .foregroundColor(FancyColor.subtext.color)
                    .padding(.trailing, 12)
            }
        }
    }
    
    var heartLeftView: some View {
        Group {
            if heartCount > 0 {
                Image("ic_love")
                    .foregroundColor(FancyColor.red.color)
                    .padding(.bottom, -8)
                    .padding(.trailing, -8)
                    .scaleEffect(scale)
                    .zIndex(10)
            }
        }
    }
    
    var dateLeftView: some View {
        Group {
            if let date = date {
                Text(date)
                    .font(.system(size: 11))
                    .foregroundColor(FancyColor.subtext.color)
                    .padding(.leading, 12)
            }
        }
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            if me {
                Spacer()
                if userTraceType == .studyStart {
                    ZStack(alignment: .bottomLeading) {
                        heartRightView
                        AlarmRightBubbleView(nickname: nickname, content: content, showIcon: true, heartCount: $heartCount, scale: $scale)
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
                } else if userTraceType == .studyEnd {
                    dateRightView
                    ZStack(alignment: .bottomLeading) {
                        heartRightView
                        AlarmRightBubbleView(nickname: nickname, content: content, showIcon: false, heartCount: $heartCount, scale: $scale)
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
                } else {
                    dateRightView
                    ZStack(alignment: .bottomLeading) {
                        heartRightView
                        MessageRightBubbleView(content: content, imageURL: imageURL, heartCount: $heartCount, scale: $scale)
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
            } else {
                if userTraceType == .studyStart {
                    HStack(alignment: .top, spacing: 0) {
                        ProfileImageWrapperView(profileImageURL: profileImageURL)
                            .padding(.trailing, 8)
                        VStack(alignment: .leading, spacing: 0) {
                            Text(nickname)
                                .fontWeight(.semibold)
                                .font(.system(size: 13))
                                .foregroundColor(FancyColor.chatBotBubbleNickname.color)
                                .padding(.bottom, 4)
                            HStack(alignment: .bottom, spacing: 0) {
                                ZStack(alignment: .bottomTrailing) {
                                    AlarmLeftBubbleView(nickname: nickname, content: content, showIcon: true, heartCount: $heartCount, scale: $scale)
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
                                    heartLeftView
                                }
                                dateLeftView
                            }
                        }
                    }
                } else if userTraceType == .studyEnd {
                    HStack(alignment: .top, spacing: 0) {
                        ProfileImageWrapperView(profileImageURL: profileImageURL)
                            .padding(.trailing, 8)
                        VStack(alignment: .leading, spacing: 0) {
                            Text(nickname)
                                .fontWeight(.semibold)
                                .font(.system(size: 13))
                                .foregroundColor(FancyColor.chatBotBubbleNickname.color)
                                .padding(.bottom, 4)
                            HStack(alignment: .bottom, spacing: 0) {
                                ZStack(alignment: .bottomTrailing) {
                                    AlarmLeftBubbleView(nickname: nickname, content: content, showIcon: false, heartCount: $heartCount, scale: $scale)
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
                                    heartLeftView
                                }
                                dateLeftView
                            }
                        }
                    }
                } else {
                    HStack(alignment: .top, spacing: 0) {
                        ProfileImageWrapperView(profileImageURL: profileImageURL)
                            .padding(.trailing, 8)
                        VStack(alignment: .leading, spacing: 0) {
                            Text(nickname)
                                .fontWeight(.semibold)
                                .font(.system(size: 13))
                                .foregroundColor(FancyColor.chatBotBubbleNickname.color)
                                .padding(.bottom, 4)
                            HStack(alignment: .bottom, spacing: 0) {
                                ZStack(alignment: .bottomTrailing) {
                                    MessageLeftBubbleView(content: content, imageURL: imageURL, heartCount: $heartCount, scale: $scale)
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
                                    heartLeftView
                                }
                                dateLeftView
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
