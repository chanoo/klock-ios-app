//
//  ChatInputView.swift
//  KlockApp
//
//  Created by 성찬우 on 2/17/24.
//

import SwiftUI

struct ChatInputView: View {
    @EnvironmentObject var tabBarManager: TabBarManager

    @Binding var text: String
    @Binding var dynamicHeight: CGFloat
    @Binding var isPreparingResponse: Bool
    let maxHeight: CGFloat = 70 // 최대 높이 (1줄당 대략 20~25 정도를 예상하고 세팅)

    var body: some View {
        HStack(spacing: 0) {
            HStack(alignment: .bottom, spacing: 0) {
                ZStack(alignment: .bottomTrailing) {
                    TextView(text: $text, dynamicHeight: $dynamicHeight, maxHeight: maxHeight)
                        .frame(height: dynamicHeight)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(0)
                        .padding(.leading, 6)
                        .padding(.trailing, 25)
                        .foregroundColor(FancyColor.primary.color)
                        .background(FancyColor.chatBotInput.color)
                        .cornerRadius(4)
                        .onTapGesture {
                            tabBarManager.hide()
                        }
                }
                .padding(1)
                .background(FancyColor.chatBotInputOutline.color)
                .cornerRadius(4)

                Button(action: {
                }) {
                    Image("ic_circle_arrow_up")
                        .foregroundColor(FancyColor.chatBotSendButton.color)
                }
                .padding(1)
                .padding(.top, 2)
                .frame(height: 40)
                .frame(width: 40)
                .disabled(isPreparingResponse)
            }
            .padding(.top, 5)
            .padding(.leading, 14)
            .padding(.trailing, 8)
            .padding(.bottom, 8)
        }
        .background(FancyColor.chatBotInputBackground.color)
    }
}
