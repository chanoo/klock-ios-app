//
//  FancyColor.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/03.
//

import SwiftUI

enum FancyColor: String {
    case facebook = "color_facebook"
    case appleBackground = "color_apple_background"
    case appleText = "color_apple_text"
    case backButtonDisable = "color_back_button_disable"
    case actionsheetBackground = "color_actionsheet_background"
    case kakao = "color_kakao"
    case kakaoBrown = "color_kakao_brown"
    case background = "color_background"
    case background2 = "color_background2"
    case blackButtonBackground = "color_black_button_background"
    case blackButtonText = "color_black_button_text"
    case blackDisabledButtonBackground = "color_black_disabled_button_background"
    case blackDisabledButtonText = "color_black_disabled_button_text"
    case button = "color_button"
    case buttonDisabled = "color_button_disabled"
    case buttonText = "color_button_text"
    case buttonOutlineBackground = "color_button_outline_background"
    case buttonOutlineForground = "color_button_outline_forground"
    case buttonOutlineLine = "color_button_outline_line"
    case buttonDisableOutlineBackground = "color_button_disable_outline_background"
    case buttonDisableOutlineForgound = "color_button_disable_outline_forground"
    case buttonDisableOutlineLine = "color_button_disable_outline_line"
    case button2 = "color_button2"
    case calendarBackground = "color_calendar_background"
    case calendarEmptyCell = "color_calendar_empty_cell"
    case bubbleAlram = "color_bubble_alram"
    case buttonCancel = "color_button_cancel"
    case navigationBar = "color_navigation_bar"
    case listCell = "color_list_cell"
    case listCellBorder = "color_list_cell_border"
    case listCellUnderline = "color_list_cell_underline"
    case header = "color_header"
    case subtext = "color_subtext"
    case tabbarBackground = "color_tabbar_background"
    case tabbarIcon = "color_tabbar_icon"
    case tabbarIconSelected = "color_tabbar_icon_selected"
    case text = "color_text"
    case textfieldUnderline = "color_textfield_underline"
    case timerFocusBackground = "color_timer_focus_background"
    case timerFocusText = "color_timer_focus_text"
    case timerOutline = "color_timer_outline"
    case backButton = "color_back_button"
    case chatBotBackground = "color_chatbot_background"
    case chatBotBubble = "color_chatbot_bubble"
    case chatBotBubbleMe = "color_chatbot_bubble_me"
    case chatBotBubbleNickname = "color_chatbot_bubble_nickname"
    case chatbotBubbleTextMe = "color_chatbot_bubble_text_me"
    case chatbotBubbleText = "color_chatbot_bubble_text"
    case chatBotInput = "color_chatbot_input"
    case chatBotListCell = "color_chatbot_list_cell"
    case chatBotInputOutline = "color_chatbot_input_outline"
    case chatBotInputBackground = "color_chatbot_input_background"
    case chatBotUploadButton = "color_chatbot_upload_button"
    case chatBotSendButton = "color_chatbot_send_button"
    case profileImageBorder = "color_profile_image_border"
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
    case imagePlaceholder = "color_image_placeholder"
    case launchBackground = "color_launch_background"
    case launchSymbol = "color_launch_symbol"
    case clear = "color_clear"

    var color: Color {
        Color(self.rawValue)
    }
}
