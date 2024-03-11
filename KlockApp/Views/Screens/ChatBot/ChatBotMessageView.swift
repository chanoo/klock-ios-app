//
//  ChatBotMessageView.swift
//  KlockApp
//
//  Created by 성찬우 on 3/11/24.
//

import SwiftUI

struct ChatBotMessageView: View {
    @EnvironmentObject var actionSheetManager: ActionSheetManager
    
    var me: Bool
    var nickname: String
    var profileImageURL: String?
    var content: String
    
    init(me: Bool, nickname: String, profileImageURL: String? = nil, content: String) {
        self.me = me
        self.nickname = nickname
        self.profileImageURL = profileImageURL
        self.content = content
    }

    var body: some View {
        Group {
            if me {
                HStack(alignment: .bottom, spacing: 0) {
                    Spacer()
                    ZStack(alignment: .bottomLeading) {
                        MessageRightBubbleView(content: content, imageURL: nil, heartCount: .constant(0), onHeart: {}, scale: .constant(0))
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
                                MessageLeftBubbleView(content: content, imageURL: nil, heartCount: .constant(0), onHeart: {}, scale: .constant(0))
                            }
                        }
                    }
                    Spacer()
                }
            }
        }
        .padding(.top, 4)
        .padding(.bottom, 4)
        .padding(.leading, me ? 8 : 16)
        .padding(.trailing, me ? 16 : 8)
    }
}
