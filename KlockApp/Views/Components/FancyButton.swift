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
    case black

    var backgroundColor: Color {
        switch self {
        case .primary:
            return FancyColor.primary.color
        case .secondary:
            return FancyColor.white.color
        case .outline:
            return FancyColor.buttonOutlineBackground.color
        case .facebook:
            return FancyColor.facebook.color
        case .apple:
            return FancyColor.appleBackground.color
        case .kakao:
            return FancyColor.kakao.color
        case .button:
            return FancyColor.button.color
        case .black:
            return FancyColor.blackButtonBackground.color
        }
    }

    var foregroundColor: Color {
        switch self {
        case .primary:
            return FancyColor.white.color
        case .secondary:
            return FancyColor.primary.color
        case .outline:
            return FancyColor.buttonOutlineForground.color
        case .facebook:
            return FancyColor.white.color
        case .apple:
            return FancyColor.appleText.color
        case .kakao:
            return FancyColor.kakaoBrown.color
        case .button:
            return FancyColor.white.color
        case .black:
            return FancyColor.blackButtonText.color
        }
    }
    
    var outlineColor: Color {
        switch self {
        case .primary:
            return FancyColor.primary.color
        case .secondary:
            return FancyColor.white.color
        case .outline:
            return FancyColor.buttonOutlineLine.color
        case .facebook:
            return FancyColor.facebook.color
        case .apple:
            return FancyColor.appleBackground.color
        case .kakao:
            return FancyColor.kakao.color
        case .button:
            return FancyColor.black.color
        case .black:
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
            return FancyColor.appleBackground.color
        case .kakao:
            return FancyColor.kakao.color
        case .button:
            return FancyColor.gray2.color
        case .black:
            return FancyColor.backButtonDisable.color
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
    @State private var isTapped = false

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
            if isTapped {
                action?()
            }
        }) {
            buttonContent
        }
        .simultaneousGesture(LongPressGesture(minimumDuration: 0.5).onChanged { _ in
            isTapped = true
        }.onEnded { _ in
            longPressAction?()
            isTapped = false
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
                .font(.system(size: 15, weight: .bold))
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
        .frame(maxWidth: isBlock ? .infinity : nil, minHeight: 52)
        .background(disabled ?? false ? style.disableColor : style.backgroundColor)
        .cornerRadius(4)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(style.outlineColor, lineWidth: bordered ? 1 : 0)
        )
    }
}
