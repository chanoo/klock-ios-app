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
    case button

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
        case .button:
            return FancyColor.black.color
        }
    }

    var foregroundColor: Color {
        switch self {
        case .primary:
            return FancyColor.white.color
        case .secondary:
            return FancyColor.primary.color
        case .outline:
            return FancyColor.black.color
        case .facebook:
            return FancyColor.white.color
        case .apple:
            return FancyColor.white.color
        case .kakao:
            return FancyColor.kakao_brown.color
        case .button:
            return FancyColor.white.color
        }
    }
    
    var outlineColor: Color {
        switch self {
        case .primary:
            return FancyColor.primary.color
        case .secondary:
            return FancyColor.white.color
        case .outline:
            return FancyColor.gray1.color
        case .facebook:
            return FancyColor.facebook.color
        case .apple:
            return FancyColor.black.color
        case .kakao:
            return FancyColor.kakao.color
        case .button:
            return FancyColor.black.color
        }
    }
    
    var disableColor: Color {
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
        case .button:
            return FancyColor.gray2.color
        }
    }

}

struct FancyButton: View {
    let title: String
    let action: (() -> Void)?
    let longPressAction: (() -> Void)?
    let bordered: Bool
    let icon: Image?
    let isBlock: Bool
    @Binding var disabled: Bool?
    @Binding var style: FancyButtonStyle

    init(title: String,
         action: (() -> Void)? = nil,
         longPressAction: (() -> Void)? = nil,
         bordered: Bool = false,
         icon: Image? = nil,
         isBlock: Bool = true,
         disabled: Binding<Bool?> = .constant(false),
         style: Binding<FancyButtonStyle>) {
        self.title = title
        self.action = action
        self.longPressAction = longPressAction
        self.bordered = bordered
        self.icon = icon
        self.isBlock = isBlock
        self._disabled = disabled
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
        .padding(.leading, 15)
        .padding(.trailing, 15)
        .frame(maxWidth: isBlock ? .infinity : nil, minHeight: 52)
        .background(disabled ?? false ? style.disableColor : style.backgroundColor)
        .cornerRadius(4)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(style.outlineColor, lineWidth: bordered ? 1 : 0)
        )
    }
}
