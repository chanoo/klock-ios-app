//
//  FancyColor.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/03.
//

import SwiftUI

enum FancyColor: String {
    case primary = "ColorPrimary"
    case secondary = "ColorSecondary"
    case facebook = "ColorFacebook"
    case background = "ColorBackground"

    var color: Color {
        Color(self.rawValue)
    }
}
