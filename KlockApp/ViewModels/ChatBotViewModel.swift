//
//  ChatGPTViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/12.
//

import Combine
import Foundation

class ChatBotViewModel: ObservableObject {
    @Published var chatBots: [ChatBotModel] = [] // 수정
    @Published var messages: [Int64?: [MessageModel]] = [:] // 수정
    @Published var tempMessage: MessageModel?
    @Published var newMessage: String = ""
    @Published var isPreparingResponse: Bool = false // 추가

    var cancellables: Set<AnyCancellable> = []

    private let chatGPTService: ChatGPTServiceProtocol = Container.shared.resolve(ChatGPTServiceProtocol.self)
    private let chatBotService: ChatBotServiceProtocol = Container.shared.resolve(ChatBotServiceProtocol.self)

    init() {
        getActiveChatBots()
    }

    func sendMessage(chatBotID: Int64?) {
        guard !newMessage.isEmpty else { return }

        let userMessage = MessageModel(
            content: newMessage,
            role: "user",
            chatBotID: chatBotID)
        messages[chatBotID, default: []].append(userMessage)

        self.isPreparingResponse = true

        chatGPTService.send(messages: messages[chatBotID] ?? [], onReceived: { [weak self] response in
            DispatchQueue.main.async {
                if let existingContent = self?.tempMessage?.content {
                    let updatedContent = existingContent + response
                    let aiMessage = MessageModel(content: updatedContent, role: "assistant", chatBotID: chatBotID)
                    self?.tempMessage = aiMessage
                } else {
                    let aiMessage = MessageModel(content: response, role: "assistant", chatBotID: chatBotID)
                    self?.tempMessage = aiMessage
                }
            }
        }, completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if let tempMessage = self?.tempMessage {
                        self?.messages[chatBotID, default: []].append(tempMessage)
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

    private func getActiveChatBots() {
        chatBotService.getActiveChatBots()
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] chatBots in
                guard let self = self else { return }
                self.chatBots = chatBots

                // Add persona as a system message for chatbots with empty conversation history
                for chatBot in chatBots {
                    if self.messages[chatBot.id]?.isEmpty ?? true {
                        let systemMessage = MessageModel(content: chatBot.persona, role: "system", chatBotID: chatBot.id)
                        self.messages[chatBot.id] = [systemMessage]
                    }
                }
            }.store(in: &cancellables)
    }

}
