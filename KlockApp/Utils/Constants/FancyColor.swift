//
//  FancyColor.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/03.
//

import SwiftUI

enum FancyColor: String {
    case primary = "color_primary"
    case secondary = "color_secondary"
    case facebook = "color_facebook"
    case background = "color_background"
    case gray9 = "color_gray9"

    var color: Color {
        Color(self.rawValue)
    }
}
