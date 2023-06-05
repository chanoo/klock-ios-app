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
    @Binding var firstResponder: Bool
    var onCommit: (() -> Void)?

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
                    
                    Image("ic_check_o")
                        .foregroundColor(.black)
                }
            } else {
                HStack {
                    TextField(placeholder, text: $text, onCommit: {
                        onCommit?()
                    })
                    .keyboardType(keyboardType ?? .default)
                    .focused($isFocused)
                    
                    Image("ic_check_o")
                        .foregroundColor(.black)
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
