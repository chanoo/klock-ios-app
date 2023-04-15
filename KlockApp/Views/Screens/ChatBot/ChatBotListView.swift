//
//  ChatBotListView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/13.
//

import SwiftUI

struct ChatBotListView: View {
    @ObservedObject var viewModel: ChatBotViewModel = Container.shared.resolve(ChatBotViewModel.self)

    var body: some View {
        VStack(spacing: 0) {
            List(viewModel.chatBots) { chatBot in
                NavigationLink(destination: ChatBotChatView(viewModel: viewModel, chatBot: chatBot)) {
                    Text(chatBot.title)
                }
            }
        }
    }
}

struct ChatBotListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatBotListView()
    }
}
