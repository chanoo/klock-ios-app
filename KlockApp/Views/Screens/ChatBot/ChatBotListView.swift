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
            List {
                Section(
                    header: Text("AI 선생님에게\n언제든 질문해보세요")
                        .font(.system(size: 24, weight: .bold))
                        .lineSpacing(4)
                        .padding(.top)
                        .padding(.bottom)
                        .foregroundColor(FancyColor.header.color)
                ) {
                    ForEach(viewModel.chatBots, id: \.id) { chatBot in
                        ChatBotRow(chatBot: chatBot)
                            .background{
                                NavigationLink(destination:ChatBotChatView(chatBot: chatBot).environmentObject(viewModel)) {
                                }
                                .opacity(0)
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                            .padding(.leading, 15)
                            .padding(.trailing, 15)
                            .padding(.bottom, 10)
                            .background(FancyColor.background.color)
                    }
                }
            }
            .listStyle(.plain)
        }
        .navigationBarTitle("Ai 선생님", displayMode: .inline)
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
                    .foregroundColor(FancyColor.text.color)
                
                Spacer()
                
                Text(chatBot.title)
                    .font(.subheadline)
                    .lineLimit(1)
                Spacer()
            }
            .padding(.leading, 10)
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(FancyColor.listCell.color)
        .cornerRadius(4)
    }
}

struct ChatBotListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = Container.shared.resolve(ChatBotViewModel.self)
        ChatBotListView()
            .environmentObject(viewModel)
            .background(FancyColor.background.color)
    }
}
