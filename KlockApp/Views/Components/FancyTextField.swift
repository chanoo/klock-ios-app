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
    @Binding var error: String?
    let maxLength: Int?
    @Binding var firstResponder: Bool
    var onCommit: (() -> Void)?
    
    init(
        placeholder: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType? = .default,
        isSecureField: Bool? = false,
        isValid: Bool? = nil,
        error: Binding<String?> = .constant(nil),
        maxLength: Int? = nil,
        firstResponder: Binding<Bool>,
        onCommit: ( () -> Void)? = nil)
    {
        self.placeholder = placeholder
        self._text = text
        self.keyboardType = keyboardType
        self.isSecureField = isSecureField
        self.isValid = isValid
        self._error = error
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
                    TextField(
                        placeholder,
                        text: $text,
                        onCommit: {
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
                .foregroundColor((text.count == 0 || error?.count ?? 0 == 0) ? FancyColor.textfieldUnderline.color : FancyColor.red.color)
            HStack {
                if let error = error, text.count > 0 {
                    Text(error)
                        .font(.system(size: 13))
                        .foregroundColor(FancyColor.red.color)
                        .padding([.top, .leading], 6)
                }
                Spacer() // 오른쪽 정렬을 위해 Spacer 추가
                if let maxLength = maxLength {
                    Text("\(text.count) / \(maxLength)")
                        .font(.system(size: 13))
                        .foregroundColor((text.count == 0 || error?.count ?? 0 == 0) ? FancyColor.text.color : FancyColor.red.color)
                        .padding([.top, .trailing], 6)
                }
            }
        }
        .onChange(of: firstResponder) { newValue in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.isFocused = newValue
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
        if error?.count ?? 0 == 0 {
            return ""
        } else {
            return "ic_circle_cross"
        }
    }
}

struct FancyTextField_Previews: PreviewProvider {
    static var previews: some View {
        FancyTextField(
            placeholder: "닉네임을 입력해주세요",
            text: .constant("hello"),
            keyboardType: .default,
            isSecureField: false,
            isValid: false,
            error: .constant("다른 친구가 이미 사용 중이에요"),
            maxLength: 10,
            firstResponder: .constant(false)
        )
    }
}
