//
//  FancyButton.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/03/31.
//

import SwiftUI
import Foast

enum FancyButtonSize {
    case large
    case medium
    case small
}

enum FancyButtonTextAlign {
    case leading
    case center
    case trailing
}

enum FancyButtonStyle {
    case primary
    case secondary
    case outline
    case facebook
    case apple
    case kakao
    case button
    case black
    case text

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
        case .text:
            return FancyColor.clear.color
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
            return FancyColor.buttonText.color
        case .black:
            return FancyColor.blackButtonText.color
        case .text:
            return FancyColor.buttonOutlineForground.color
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
        case .text:
            return FancyColor.clear.color
        }
    }
    
    var disableBackgroundColor: Color {
        switch self {
        case .primary:
            return FancyColor.primary.color
        case .secondary:
            return FancyColor.white.color
        case .outline:
            return FancyColor.buttonDisableOutlineBackground.color
        case .facebook:
            return FancyColor.facebook.color
        case .apple:
            return FancyColor.appleBackground.color
        case .kakao:
            return FancyColor.kakao.color
        case .button:
            return FancyColor.blackDisabledButtonBackground.color
        case .black:
            return FancyColor.backButtonDisable.color
        case .text:
            return FancyColor.clear.color
        }
    }
    
    var disableForgroundColor: Color {
        switch self {
        case .primary:
            return FancyColor.white.color
        case .secondary:
            return FancyColor.primary.color
        case .outline:
            return FancyColor.buttonDisableOutlineForgound.color
        case .facebook:
            return FancyColor.white.color
        case .apple:
            return FancyColor.appleText.color
        case .kakao:
            return FancyColor.kakaoBrown.color
        case .button:
            return FancyColor.blackDisabledButtonText.color
        case .black:
            return FancyColor.blackButtonText.color
        case .text:
            return FancyColor.buttonDisableOutlineForgound.color
        }
    }
    
    var disableOutlineColor: Color {
        switch self {
        case .primary:
            return FancyColor.primary.color
        case .secondary:
            return FancyColor.white.color
        case .outline:
            return FancyColor.buttonDisableOutlineLine.color
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
        case .text:
            return FancyColor.clear.color
        }
    }
}

struct FancyButton: View {
    let title: String
    let action: (() -> Void)?
    let disableAction: (() -> Void)?
    var alignment: FancyButtonTextAlign? = .center
    let longPressAction: (() -> Void)?
    let icon: Image?
    let isBlock: Bool
    @Binding var disabled: Bool?
    let size: FancyButtonSize
    @Binding var style: FancyButtonStyle
    @State private var isTapped = false

    init(title: String,
         action: (() -> Void)? = nil,
         disableAction: (() -> Void)? = nil,
         alignment: FancyButtonTextAlign? = .center,
         longPressAction: (() -> Void)? = nil,
         icon: Image? = nil,
         isBlock: Bool = true,
         disabled: Binding<Bool?> = .constant(false),
         size: FancyButtonSize = .medium,
         style: Binding<FancyButtonStyle>) {
        self.title = title
        self.action = action
        self.disableAction = disableAction
        self.alignment = alignment
        self.longPressAction = longPressAction
        self.icon = icon
        self.isBlock = isBlock
        self._disabled = disabled
        self.size = size
        self._style = style
    }

    var body: some View {
        Button(action: {
            if isTapped {
                if disabled ?? false {
                    disableAction?()
                } else {
                    action?()
                }
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
            if alignment == .trailing {
                Spacer()
            }
            Group {
                if let icon = icon {
                    icon
                        .foregroundColor(style.foregroundColor)
                        .padding(.trailing, 12)
                }
                Text(title)
                    .foregroundColor(disabled ?? false ? style.disableForgroundColor : style.foregroundColor)
                    .font(.system(size: 15, weight: .bold))
            }
            if alignment == .leading {
                Spacer()
            }
        }
        .padding(6)
        .padding(.leading, size == .medium ? 20 : 6)
        .padding(.trailing, size == .medium ? 20 : 6)
        .frame(maxWidth: isBlock ? .infinity : nil, minHeight: size == .medium ? 52 : 0)
        .background(disabled ?? false ? style.disableBackgroundColor : style.backgroundColor)
        .cornerRadius(4)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(disabled ?? false ? style.disableOutlineColor : style.outlineColor, lineWidth: 1)
        )
    }
}
