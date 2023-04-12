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
        if isSecureField == true {
            SecureField(placeholder, text: $text, onCommit: {
                onCommit?()
            })
            .keyboardType(keyboardType ?? .default)
            .focused($isFocused)
            .padding()
            .background(Color.white)
            .cornerRadius(22)
            .onChange(of: firstResponder) { value in
                if value {
                    isFocused = true
                } else {
                    isFocused = false
                }
            }
        } else {
            TextField(placeholder, text: $text, onCommit: {
                onCommit?()
            })
            .keyboardType(keyboardType ?? .default)
            .focused($isFocused)
            .padding()
            .background(FancyColor.background.color)
            .cornerRadius(22)
            .onChange(of: firstResponder) { value in
                if value {
                    isFocused = true
                } else {
                    isFocused = false
                }
            }
        }
    }
}
