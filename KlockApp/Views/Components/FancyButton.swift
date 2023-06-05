//
//  FancyButton.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/03/31.
//

import SwiftUI
import Foast

enum FancyButtonStyle {
    case primary
    case secondary
    case outline
    case facebook
    case apple
    case kakao

    var backgroundColor: Color {
        switch self {
        case .primary:
            return FancyColor.primary.color
        case .secondary:
            return FancyColor.white.color
        case .outline:
            return FancyColor.white.color
        case .facebook:
            return FancyColor.facebook.color
        case .apple:
            return FancyColor.apple.color
        case .kakao:
            return FancyColor.kakao.color
        }
    }

    var foregroundColor: Color {
        switch self {
        case .primary:
            return FancyColor.white.color
        case .secondary:
            return FancyColor.primary.color
        case .outline:
            return FancyColor.primary.color
        case .facebook:
            return FancyColor.white.color
        case .apple:
            return FancyColor.white.color
        case .kakao:
            return FancyColor.kakao_brown.color
        }
    }
    
    var outlineColor: Color {
        switch self {
        case .primary:
            return FancyColor.primary.color
        case .secondary:
            return FancyColor.white.color
        case .outline:
            return FancyColor.primary.color
        case .facebook:
            return FancyColor.facebook.color
        case .apple:
            return FancyColor.black.color
        case .kakao:
            return FancyColor.kakao.color
        }
    }

}

struct FancyButton: View {
    let title: String
    let action: (() -> Void)?
    let longPressAction: (() -> Void)?
    let disableColor: Color
    let bordered: Bool
    let icon: Image?
    let isBlock: Bool
    let disabled: Bool?
    let height: CGFloat
    @Binding var style: FancyButtonStyle

    init(title: String,
         action: (() -> Void)? = nil,
         longPressAction: (() -> Void)? = nil,
         disableColor: Color = FancyColor.gray9.color,
         bordered: Bool = false,
         icon: Image? = nil,
         isBlock: Bool = true,
         disabled: Bool = false,
         height: CGFloat = 52,
         style: Binding<FancyButtonStyle>) {
        self.title = title
        self.action = action
        self.longPressAction = longPressAction
        self.disableColor = disableColor
        self.bordered = bordered
        self.icon = icon
        self.isBlock = isBlock
        self.disabled = disabled
        self.height = height
        self._style = style
    }

    var body: some View {
        Button(action: {
            action?()
        }) {
            buttonContent
        }
        .simultaneousGesture(LongPressGesture().onEnded { _ in
            longPressAction?()
            print("Button was long pressed")
        })
    }

    var buttonContent: some View {
        HStack(spacing: 0) {
            if let icon = icon {
                icon
                    .foregroundColor(style.foregroundColor)
                    .padding(.trailing, 12)
            }
            Text(title)
                .foregroundColor(style.foregroundColor)
                .fontWeight(.bold)
        }
        .padding(.leading, 30)
        .padding(.trailing, 30)
        .frame(maxWidth: isBlock ? .infinity : nil, minHeight: height)
        .background(disabled ?? false ? disableColor : style.backgroundColor)
        .cornerRadius(4)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(style.outlineColor.opacity(0.3), lineWidth: bordered ? 1 : 0)
        )
    }
}
