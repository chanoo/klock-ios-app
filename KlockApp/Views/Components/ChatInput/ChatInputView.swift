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
    let onSend: (String) -> Void // 클로저 추가
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
                }
                .padding(1)
                .background(FancyColor.chatBotInputOutline.color)
                .cornerRadius(4)

                Button(action: {
                    if !text.isEmpty {
                        onSend(text) // 버튼을 눌렀을 때 클로저 실행
                        text = ""
                    }
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
        .onAppear {
            NotificationCenter.default.addObserver(
                forName: UIResponder.keyboardWillShowNotification,
                object: nil,
                queue: .main) { _ in
                    self.tabBarManager.hide()
                }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(
                self,
                name: UIResponder.keyboardWillShowNotification,
                object: nil)
        }
    }
}
