//
//  FancyTextField.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/03/31.
//

import SwiftUI

struct FancyTextField: View {
    let placeholder: String
    @Binding var text: String
    let keyboardType: UIKeyboardType?
    let isSecureField: Bool?
    let isValid: Bool?
    let maxLength: Int?
    @Binding var firstResponder: Bool
    var onCommit: (() -> Void)?
    
    init(
        placeholder: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType? = .default,
        isSecureField: Bool? = false,
        isValid: Bool? = nil,
        maxLength: Int? = nil,
        firstResponder: Binding<Bool>,
        onCommit: ( () -> Void)? = nil)
    {
        self.placeholder = placeholder
        self._text = text
        self.keyboardType = keyboardType
        self.isSecureField = isSecureField
        self.isValid = isValid
        self.maxLength = maxLength
        self._firstResponder = firstResponder
        self.onCommit = onCommit
    }

    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            if isSecureField == true {
                HStack {
                    SecureField(placeholder, text: $text, onCommit: {
                        onCommit?()
                    })
                    .foregroundColor(FancyColor.text.color)
                    .keyboardType(keyboardType ?? .default)
                    .focused($isFocused)
                    
                    Image(imageName)
                        .foregroundColor(.black)
                        .opacity(text.count == 0 ? 0 : 1) // 이미지를 보이지 않게 하려면 opacity를 0으로 설정
                }
                .padding([.top, .bottom], 8)
                .padding([.leading, .trailing], 4)
            } else {
                HStack {
                    TextField(placeholder, text: $text, onCommit: {
                        onCommit?()
                    })
                    .foregroundColor(FancyColor.text.color)
                    .keyboardType(keyboardType ?? .default)
                    .focused($isFocused)
                    
                    Image(imageName)
                        .foregroundColor(.black)
                        .opacity(text.count == 0 ? 0 : 1) // 이미지를 보이지 않게 하려면 opacity를 0으로 설정
                    
                }
                .padding([.top, .bottom], 8)
                .padding([.leading, .trailing], 4)
            }
            Rectangle()
                .frame(height: 1)
                .foregroundColor((text.count == 0 || isValid == true) ? FancyColor.textfieldUnderline.color : FancyColor.red.color)
            if let maxLength = maxLength {
                HStack {
                    Spacer() // 오른쪽 정렬을 위해 Spacer 추가
                    Text("\(text.count) / \(maxLength)")
                        .font(.caption)
                        .foregroundColor(FancyColor.black.color)
                        .padding([.top, .trailing], 4)
                }
            }
        }
        .background(FancyColor.textfieldBackground.color)
        .onChange(of: firstResponder) { value in
            if value {
                isFocused = true
            } else {
                isFocused = false
            }
        }
        .onChange(of: text) { newValue in
            if let maxLength = maxLength, newValue.count > maxLength {
                text = String(newValue.prefix(maxLength))
            }
        }
    }
    
    private var imageName: String {
        // isValid 값에 따라 이미지 이름을 결정
        if isValid == true {
            return "ic_check_o"
        } else {
            return "ic_circle_cross"
        }
    }
}

struct FancyTextField_Previews: PreviewProvider {
    static var previews: some View {
        FancyTextField(
            placeholder: "닉네임",
            text: .constant(""),
            keyboardType: .default,
            isSecureField: false,
            firstResponder: .constant(false)
        )
    }
}
