//
//  ChatGPTViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/12.
//

import Combine
import Foundation

class ChatBotViewModel: ObservableObject {
    @Published var chatBots: [ChatBotModel] = []
    @Published var messages: [Int64?: [MessageModel]] = [:]
    @Published var tempMessage: MessageModel?
    @Published var newMessage: String = ""
    @Published var isPreparingResponse: Bool = false

    var cancellables: Set<AnyCancellable> = []

    private let chatGPTService: ChatGPTServiceProtocol = Container.shared.resolve(ChatGPTServiceProtocol.self)
    private let chatBotService: ChatBotServiceProtocol = Container.shared.resolve(ChatBotServiceProtocol.self)
    private let messageService: MessageServiceProtocol = Container.shared.resolve(MessageServiceProtocol.self)

    init() {
        getActiveChatBots()
    }

    func sendMessage(chatBotID: Int64?) {
        guard !newMessage.isEmpty else { return }

        let userMessage = MessageModel(content: newMessage, role: "user", chatBotID: chatBotID)
        saveAndAppendMessage(userMessage, chatBotID: chatBotID) // 변경: 메서드로 분리

        isPreparingResponse = true

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
                        self?.saveAndAppendMessage(tempMessage, chatBotID: chatBotID) // 변경: 메서드로 분리
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

    private func saveAndAppendMessage(_ message: MessageModel, chatBotID: Int64?) { // 추가: 메서드
        messages[chatBotID, default: []].append(message)
        messageService.saveMessage(message: message)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    func loadStoredMessages(chatBotID: Int64?) {
        for chatBot in chatBots {
            messageService.fetchMessages(chatBotID: chatBot.id)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                    }
                } receiveValue: { [weak self] fetchedMessages in
                    self?.messages[chatBot.id] = fetchedMessages
                }
                .store(in: &cancellables)
        }
    }
    
    private func getActiveChatBots() {
        chatBotService.getActiveChatBots()
            .sink { completion in
                // ...
            } receiveValue: { [weak self] chatBots in
                guard let self = self else { return }
                self.chatBots = chatBots
            }.store(in: &cancellables)
    }
    
}
