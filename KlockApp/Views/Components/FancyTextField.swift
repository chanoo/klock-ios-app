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
    @Binding var firstResponder: Bool
    var onCommit: (() -> Void)?
    
    init(
        placeholder: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType? = .default,
        isSecureField: Bool? = false,
        isValid: Bool? = nil,
        firstResponder: Binding<Bool>,
        onCommit: ( () -> Void)? = nil)
    {
        self.placeholder = placeholder
        self._text = text
        self.keyboardType = keyboardType
        self.isSecureField = isSecureField
        self.isValid = isValid        
        self._firstResponder = firstResponder
        self.onCommit = onCommit
    }

    @FocusState private var isFocused: Bool

    var body: some View {
        VStack {
            if isSecureField == true {
                HStack {
                    SecureField(placeholder, text: $text, onCommit: {
                        onCommit?()
                    })
                    .keyboardType(keyboardType ?? .default)
                    .focused($isFocused)
                    
                    Image(imageName)
                        .foregroundColor(.black)
                        .opacity(text.count == 0 ? 0 : 1) // 이미지를 보이지 않게 하려면 opacity를 0으로 설정
                }
            } else {
                HStack {
                    TextField(placeholder, text: $text, onCommit: {
                        onCommit?()
                    })
                    .keyboardType(keyboardType ?? .default)
                    .focused($isFocused)
                    
                    Image(imageName)
                        .foregroundColor(.black)
                        .opacity(text.count == 0 ? 0 : 1) // 이미지를 보이지 않게 하려면 opacity를 0으로 설정
                }
            }
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.black)
        }
        .background(Color.white)
        .onChange(of: firstResponder) { value in
            if value {
                isFocused = true
            } else {
                isFocused = false
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
