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
    case kakao_brown = "color_kakao_brown"
    case background = "color_background"
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
