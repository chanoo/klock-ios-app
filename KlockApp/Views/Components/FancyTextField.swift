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
    let keyboardType: UIKeyboardType
    let isSecureField: Bool
    
    init(placeholder: String, text: Binding<String>, keyboardType: UIKeyboardType = .default, isSecureField: Bool = false) {
        self.placeholder = placeholder
        self._text = text
        self.keyboardType = keyboardType
        self.isSecureField = isSecureField
    }
    
    var body: some View {
        Group {
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .keyboardType(keyboardType)
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(5)
    }
}
