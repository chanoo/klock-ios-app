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
    @Environment(\.colorScheme) var colorScheme
    var chatBot: ChatBotModel
    @FocusState private var isFocused: Bool
    @State private var dynamicHeight: CGFloat = 20 // 높이 초기값
    let maxHeight: CGFloat = 70 // 최대 높이 (1줄당 대략 20~25 정도를 예상하고 세팅)
    
    // 음성 인식 관련 변수
    @StateObject private var speechService = SpeechService()
    @State private var isRecording = false

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) { // 스크롤바 숨김
                ScrollViewReader { _ in
                    LazyVStack {

                        if viewModel.isPreparingResponse && viewModel.tempMessage == nil {
                            HStack(spacing: 0) {
                                Spacer()
                                ProgressView()
                                    .padding()
                                    .background(FancyColor.chatBotBubble.color)
                                    .clipShape(RoundedCorners(tl: 10, tr: 0, bl: 10, br: 10))
                                    .foregroundColor(colorScheme == .dark ? Color.white : FancyColor.primary.color)
                            }
                            .padding(.leading, 10)
                            .padding(.trailing, 24)
                            .padding(.top, 10)
                        }
                        
                        if let tempMessage = viewModel.tempMessage {
                            ChatBubble(messageModel: tempMessage, isPreparingResponse: $viewModel.isPreparingResponse)
                        }
                        
                        ForEach(viewModel.messages[chatBot.id, default: []].reversed()) { messageModel in
                            ChatBubble(messageModel: messageModel, isPreparingResponse: $viewModel.isPreparingResponse)
                        }

                    }
                }
            }
            .rotationEffect(.degrees(180), anchor: .center)

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
                            .foregroundColor(colorScheme == .dark ? .gray : FancyColor.primary.color)
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

struct ChatBubble: View {
    let messageModel: MessageModel
    @Binding var isPreparingResponse: Bool

    var body: some View {
        VStack {
            HStack {
                if messageModel.isUser {
                    Spacer()
                    Text(messageModel.content)
                        .padding()
                        .background(FancyColor.chatBotBubbleMe.color)
                        .clipShape(RoundedCorners(tl: 10, tr: 10, bl: 10, br: 0))
                        .foregroundColor(FancyColor.chatbotBubbleTextMe.color)
                } else {
                    Text(messageModel.content)
                        .padding()
                        .background(FancyColor.chatBotBubble.color)
                        .clipShape(RoundedCorners(tl: 10, tr: 10, bl: 0, br: 10))
                        .foregroundColor(FancyColor.chatbotBubbleText.color)
                    Spacer()
                }
            }
            .padding(0)
            .padding(.bottom, 5)
            .padding(.leading, messageModel.isUser ? 24 : 10)
            .padding(.trailing, messageModel.isUser ? 10 : 24)
        }
        .rotationEffect(.degrees(180), anchor: .center) // VStack을 180도 회전
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
