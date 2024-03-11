//
//  ChatGPTView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/12.
//

import SwiftUI

struct ChatBotChatView: View {
    @EnvironmentObject var viewModel: ChatBotViewModel
    @State private var showAlert = false
    var chatBot: ChatBotModel
    @FocusState private var isFocused: Bool
    @State private var dynamicHeight: CGFloat = 20 // 높이 초기값
    let maxHeight: CGFloat = 70 // 최대 높이 (1줄당 대략 20~25 정도를 예상하고 세팅)
    
    // 음성 인식 관련 변수
    @StateObject private var speechService = SpeechService()
    @State private var isRecording = false

    var body: some View {
        VStack(spacing: 0) {
            ScrollView { // 스크롤바 숨김
                ScrollViewReader { _ in
                    LazyVStack {
                        if viewModel.isPreparingResponse && viewModel.tempMessage == nil {
                            HStack(alignment: .top, spacing: 0) {
                                ProfileImageWrapperView(profileImageURL: chatBot.chatBotImageUrl)
                                    .padding(.trailing, 8)
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(chatBot.name)
                                        .fontWeight(.semibold)
                                        .font(.system(size: 13))
                                        .foregroundColor(FancyColor.chatBotBubbleNickname.color)
                                        .padding(.bottom, 4)
                                    HStack(alignment: .bottom, spacing: 0) {
                                        ZStack(alignment: .bottomTrailing) {
                                            ProgressView()
                                                .padding(12)
                                                .background(FancyColor.chatBotBubble.color)
                                                .clipShape(RoundedCorners(tl: 0, tr: 10, bl: 10, br: 10))
                                                .foregroundColor(FancyColor.primary.color)
                                                .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 10))
                                        }
                                    }
                                }
                                Spacer()
                            }
                            .padding(.top, 4)
                            .padding(.bottom, 4)
                            .padding(.leading, 16)
                            .padding(.trailing, 8)
                            .upsideDown()
                        }
                        if let tempMessage = viewModel.tempMessage {
                            ChatBotMessageView(
                                me: tempMessage.isUser,
                                nickname: chatBot.name,
                                profileImageURL: chatBot.chatBotImageUrl,
                                content: tempMessage.content
                            )
                            .upsideDown()
                        }
                        ForEach(viewModel.messages[chatBot.id, default: []].reversed()) { messageModel in
                            ChatBotMessageView(
                                me: messageModel.isUser,
                                nickname: messageModel.isUser ? viewModel.userModel?.nickname ?? "" : chatBot.name,
                                profileImageURL: messageModel.isUser ? viewModel.userModel?.profileImage : chatBot.chatBotImageUrl,
                                content: messageModel.content
                            )
                            .upsideDown()
                        }
                    }
                }
            }
            .upsideDown()

            // ChatGPTView의 body 내에서 HStack 부분
            HStack(spacing: 0) {
                HStack(alignment: .bottom, spacing: 0) {
                    ZStack(alignment: .bottomTrailing) {
                        TextView(text: $viewModel.newMessage, dynamicHeight: $dynamicHeight, maxHeight: maxHeight)
                            .frame(height: dynamicHeight)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(0)
                                .padding(.leading, 6)
                            .padding(.trailing, 25)
                            .focused($isFocused)
                            .foregroundColor(FancyColor.primary.color)
                            .background(FancyColor.chatBotInput.color)
                            .cornerRadius(4)
                            .onAppear {
                                DispatchQueue.main.async {
                                    isFocused = true
                                }
                            }
                        
                        Button(action: {
                            isRecording.toggle()
                            if isRecording {
                                try? speechService.startRecording()
                            } else {
                                speechService.stopRecording()
                            }
                        }) {
                            Image("ic_microphone")
                                .padding(.bottom, 6)
                                .padding(.trailing, 4)
                                .foregroundColor(isRecording ? FancyColor.red.color : FancyColor.gray7.color)
                        }
                    }
                    .padding(1)
                    .background(FancyColor.chatBotInputOutline.color)
                    .cornerRadius(4)

                    Button(action: {
                        viewModel.sendMessage(chatBotID: chatBot.id)
                    }) {
                        Image("ic_circle_arrow_up")
                            .foregroundColor(FancyColor.chatBotSendButton.color)
                    }
                    .padding(1)
                    .padding(.top, 2)
                    .frame(height: 40)
                    .frame(width: 40)
                    .disabled(viewModel.isPreparingResponse)
                }
                .padding(.top, 5)
                .padding(.leading, 14)
                .padding(.trailing, 8)
                .padding(.bottom, 8)
            }
            .background(FancyColor.chatBotInputBackground.color)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("대화 내용 삭제"),
                    message: Text("이 챗봇과의 모든 대화 내용을 삭제하시겠습니까?"),
                    primaryButton: .destructive(Text("삭제")) {
                        viewModel.deleteStoredMessages(chatBotID: chatBot.id)
                    },
                    secondaryButton: .cancel())
            }
        }
        .background(FancyColor.chatBotBackground.color)
        .modifier(CommonViewModifier(title: chatBot.subject))
        .navigationBarItems(
            leading: BackButtonView(),
            trailing: Button(action: {showAlert = true}) {
                Image(systemName: "trash")
            })
            .onAppear {
                viewModel.bindSpeechToMessage(speechService: speechService)
                viewModel.loadStoredMessages(chatBotID: chatBot.id)
                viewModel.initializeAssistant(chatBotID: chatBot.id, persona: chatBot.persona)
            }
    }
}

struct ChatBotChatView_Previews: PreviewProvider {
    static var previews: some View {
        let chatBotModel = ChatBotModel(id: 1, subject: "챗봇", title: "수학", name: "필즈", chatBotImageUrl: "", persona: "챗봇")
        
        let viewModel = Container.shared.resolve(ChatBotViewModel.self)
        ChatBotChatView( chatBot: chatBotModel)
            .environmentObject(viewModel)
            .background(FancyColor.background.color)
    }
}
