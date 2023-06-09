//
//  FancyColor.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/03.
//

import SwiftUI

enum FancyColor: String {
    case facebook = "color_facebook"
    case apple = "color_apple"
    case kakao = "color_kakao"
    case kakaoBrown = "color_kakao_brown"
    case background = "color_background"
    case navigationBar = "color_navigation_bar"
    case listCell = "color_list_cell"
    case header = "color_header"
    case text = "color_text"
    case backButton = "color_back_button"
    case chatBotBubble = "color_chatbot_bubble"
    case chatBotBubbleMe = "color_chatbot_bubble_me"
    case chatbotBubbleTextMe = "color_chatbot_bubble_text_me"
    case chatbotBubbleText = "color_chatbot_bubble_text"
    case chatBotInputOutline = "color_chatbot_input_outline"
    case chatBotInput = "color_chatbot_input"
    case chatBotSendButton = "color_chatbot_send_button"
    case primary = "color_primary"
    case secondary = "color_secondary"
    case gray1 = "color_gray1"
    case gray2 = "color_gray2"
    case gray3 = "color_gray3"
    case gray4 = "color_gray4"
    case gray5 = "color_gray5"
    case gray6 = "color_gray6"
    case gray7 = "color_gray7"
    case gray8 = "color_gray8"
    case gray9 = "color_gray9"
    case black = "color_black"
    case white = "color_white"
    case red = "color_red"

    case launchBackground = "color_launch_background"
    case launchSymbol = "color_launch_symbol"

    var color: Color {
        Color(self.rawValue)
    }
}
