//
//  ChatGPTView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/12.
//

import SwiftUI

struct ChatBotChatView: View {
    @StateObject var viewModel: ChatBotViewModel = Container.shared.resolve(ChatBotViewModel.self)
    @State private var scrollProxy: ScrollViewProxy?
    @Environment(\.colorScheme) var colorScheme
    var chatBot: ChatBotModel
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) { // 스크롤바 숨김
                ScrollViewReader { _ in
                    LazyVStack {
                        
                        if viewModel.isPreparingResponse && viewModel.tempMessage == nil {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .padding()
                                    .background(FancyColor.primary.color.opacity(0.2))
                                    .clipShape(RoundedCorners(tl: 10, tr: 0, bl: 10, br: 10))
                                    .foregroundColor(colorScheme == .dark ? Color.white : FancyColor.primary.color)
                            }
                            .padding(.leading, 0)
                            .padding(.trailing, 10)
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
            .rotationEffect(.degrees(180)) // ScrollView를 180도 회전
            
            // ChatGPTView의 body 내에서 HStack 부분
            HStack(spacing: 0) {
                HStack(spacing: 0) {
                    ZStack {
                        TextField("메시지 입력", text: $viewModel.newMessage)
                            .textFieldStyle(PlainTextFieldStyle()) // 기본 border 제거
                            .padding(.leading, 12) // 이 부분에서 padding값을 변경하세요.
                            .padding(.trailing, 12)
                            .frame(height: 38)
                            .focused($isFocused)
                            .foregroundColor(colorScheme == .dark ? .gray : FancyColor.primary.color)
                            .background(FancyColor.background.color)
                            .onAppear {
                                DispatchQueue.main.async {
                                    isFocused = true
                                }
                            }
                    }
                    .padding(1)
                    .background(viewModel.isPreparingResponse ? FancyColor.primary.color.opacity(0.5) : FancyColor.primary.color)

                    Button(action: {
                        viewModel.sendMessage(chatBotID: chatBot.id)
                    }) {
                        Text("보내기").foregroundColor(.white)
                    }
                    .padding(1)
                    .frame(height: 40)
                    .frame(width: 80)
                    .background(viewModel.isPreparingResponse ? FancyColor.primary.color.opacity(0.5) : FancyColor.primary.color)
                    .disabled(viewModel.isPreparingResponse)
                }
                .padding(6)
            }
            .background(FancyColor.background.color)
        }
        .modifier(CommonViewModifier(title: chatBot.subject))
        .navigationBarItems(leading: BackButtonView())
    }
}

struct ChatBubble: View {
    let messageModel: MessageModel
    @Binding var isPreparingResponse: Bool
    @Environment(\.colorScheme) var colorScheme // 이 부분을 추가하세요.

    var body: some View {
        VStack {
            HStack {
                if messageModel.isUser {
                    Spacer()
                    Text(messageModel.content)
                        .padding()
                        .background(colorScheme == .dark ? FancyColor.primary.color.opacity(0.5) : FancyColor.primary.color)
                        .clipShape(RoundedCorners(tl: 10, tr: 10, bl: 10, br: 0))
                        .foregroundColor(.white)
                } else {
                    Text(messageModel.content)
                        .padding()
                        .background(FancyColor.primary.color.opacity(0.2))
                        .clipShape(RoundedCorners(tl: 10, tr: 10, bl: 0, br: 10))
                        .foregroundColor(colorScheme == .dark ? Color.white : FancyColor.primary.color)
                    Spacer()
                }
            }
            .padding(.vertical, 2)
            .padding(.bottom, 10)
            .padding(.leading, messageModel.isUser ? 0 : 10)
            .padding(.trailing, messageModel.isUser ? 10 : 0)
            .rotationEffect(.degrees(180)) // 각 메시지 버블을 180도 회전
        }
    }
}

struct RoundedCorners: Shape {
    var tl: CGFloat = 0
    var tr: CGFloat = 0
    var bl: CGFloat = 0
    var br: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX + tl, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - tr, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - tr, y: rect.minY + tr), radius: tr, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - br))
        path.addArc(center: CGPoint(x: rect.maxX - br, y: rect.maxY - br), radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX + bl, y: rect.maxY))
        path.addArc(center: CGPoint(x: rect.minX + bl, y: rect.maxY - bl), radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + tl))
        path.addArc(center: CGPoint(x: rect.minX + tl, y: rect.minY + tl), radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)

        return path
    }
}

struct ChatBotChatView_Previews: PreviewProvider {

    @StateObject var viewModel = ChatBotViewModel()

    static var previews: some View {
        ChatBotChatView(chatBot: ChatBotModel(id: 1, subject: "국어", title: "Ai 선생님", name: "",  persona: ""))
    }
}
