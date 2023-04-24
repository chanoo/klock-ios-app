//
//  ChatBotListView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/13.
//

import SwiftUI

struct ChatBotListView: View {
    @EnvironmentObject var viewModel: ChatBotViewModel

    var body: some View {
        VStack(spacing: 0) {
            List(viewModel.chatBots, id: \.id) { chatBot in
                NavigationLink(destination: ChatBotChatView(viewModel: viewModel, chatBot: chatBot)) {
                    ChatBotRow(chatBot: chatBot)
                }
            }
        }
    }
}

struct ChatBotRow: View {
    let chatBot: ChatBotModel
    
    var body: some View {
        HStack {
            Image(chatBot.chatBotImageUrl) // Replace this with your image source
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 70, height: 70)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Spacer()
                Text("\(chatBot.subject) \(chatBot.name)")
                    .font(.headline)
                
                Spacer()
                
                Text(chatBot.title)
                    .font(.subheadline)
                    .lineLimit(1)
                Spacer()
            }
            .padding(.leading, 10)
        }
    }
}

struct ChatBotListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatBotListView()
    }
}
