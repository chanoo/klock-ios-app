//
//  ChatGPTViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/12.
//

import Combine
import Foundation

class ChatBotViewModel: ObservableObject {
    @Published var messages: [MessageModel] = []
    @Published var tempMessage: MessageModel?
    @Published var newMessage: String = ""
    @Published var isPreparingResponse: Bool = false // 추가
    @Published var chatBots: [ChatBotModel] = [
        ChatBotModel(
            id: 1,
            subject: "국어",
            title: "문장의 비결, 국어 전문가 미희 선생님",
            name: "미희",
            persona: "안녕하세요, 국어 선생님 미희입니다! 맞춤법, 작문, 독해 등 국어의 모든 것을 함께 배워볼까요? 궁금한 것이 있다면 언제든지 질문해주세요!"),
        ChatBotModel(
            id: 2,
            subject: "영어",
            title: "영어의 열쇠, 함께 찾아요 - 제이슨 선생님",
            name: "제이슨",
            persona: "Hello! I'm Jason, your English teacher. Let's improve your English skills together, from grammar and vocabulary to speaking and listening. Feel free to ask any questions!"),
        ChatBotModel(
            id: 3,
            subject: "수학",
            title: "중고등 수학의 해결사, 필즈 선생님",
            name: "필즈",
            persona: "안녕하세요, 수학 선생님 필즈입니다! 수학의 고민을 함께 나눠요. 기하, 대수, 미적분 등 어떤 주제든 도움이 필요하면 언제든지 물어봐주세요"),
        ChatBotModel(
            id: 4,
            subject: "과학",
            title: "과학 탐험의 지휘자, 남도일 선생님",
            name: "남도일",
            persona: "안녕하세요, 과학 탐험가 남도일 선생님입니다! 생물, 화학, 물리, 지구과학 등 과학의 다양한 분야를 함께 배워봅시다. 궁금한 점이 있으면 언제든지 질문해주세요!")
    ]

    private let chatGPTService: ChatGPTServiceProtocol = Container.shared.resolve(ChatGPTServiceProtocol.self)

    func sendMessage(content: String) {
        guard !newMessage.isEmpty else { return }

        let userMessage = MessageModel(content: newMessage, isUser: true)
        messages.append(userMessage)

        self.isPreparingResponse = true // 이 위치로 이동ㅌ

        chatGPTService.sendMessage(content, newMessage, onReceived: { [weak self] response in
            DispatchQueue.main.async {
                if let existingContent = self?.tempMessage?.content {
                    let updatedContent = existingContent + response
                    let aiMessage = MessageModel(content: updatedContent, isUser: false)
                    self?.tempMessage = aiMessage
                } else {
                    let aiMessage = MessageModel(content: response, isUser: false)
                    self?.tempMessage = aiMessage
                }
            }
        }, completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if let tempMessage = self?.tempMessage {
                        self?.messages.append(tempMessage)
                        self?.tempMessage = nil
                    }
                    self?.isPreparingResponse = false
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self?.isPreparingResponse = false
                }
            }
        })

        newMessage = ""
    }

}
