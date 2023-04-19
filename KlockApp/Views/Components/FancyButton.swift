//
//  FancyButton.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/03/31.
//

import SwiftUI

struct FancyButton: View {
    let title: String
    let action: () -> Void
    let backgroundColor: Color
    let foregroundColor: Color
    let icon: Image?
    let isBlock: Bool
    let height: CGFloat

    init(title: String,
         action: @escaping () -> Void,
         backgroundColor: Color,
         foregroundColor: Color,
         icon: Image? = nil,
         isBlock: Bool = true,
         height: CGFloat = 60) {
        self.title = title
        self.action = action
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.icon = icon
        self.isBlock = isBlock
        self.height = height
    }

    var body: some View {
        Button(action: action) {
            HStack {
                if let icon = icon {
                    icon
                        .foregroundColor(foregroundColor)
                        .padding(.trailing, 12)
                }
                Text(title)
                    .foregroundColor(foregroundColor)
                    .fontWeight(.bold)
            }
            .padding(.leading, 30)
            .padding(.trailing, 30)
            .frame(maxWidth: isBlock ? .infinity : nil, minHeight: height)
            .background(backgroundColor)
            .cornerRadius(height / 2)
        }
    }
}
