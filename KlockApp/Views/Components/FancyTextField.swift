//
//  FancyTextField.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/03/31.
//

import SwiftUI

struct FancyTextFieldWrapper: UIViewRepresentable {
    let placeholder: String
    @Binding var text: String
    let keyboardType: UIKeyboardType
    let isSecureField: Bool
    @Binding var firstResponder: Bool

    init(placeholder: String, text: Binding<String>, keyboardType: UIKeyboardType = .default, isSecureField: Bool = false, firstResponder: Binding<Bool>) {
        self.placeholder = placeholder
        self._text = text
        self.keyboardType = keyboardType
        self.isSecureField = isSecureField
        self._firstResponder = firstResponder
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.keyboardType = keyboardType
        textField.isSecureTextEntry = isSecureField
        textField.delegate = context.coordinator
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidChange(_:)), for: .editingChanged)
        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        uiView.placeholder = placeholder

        if firstResponder {
            uiView.becomeFirstResponder()
        } else {
            uiView.resignFirstResponder()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var fancyTextFieldWrapper: FancyTextFieldWrapper

        init(_ fancyTextFieldWrapper: FancyTextFieldWrapper) {
            self.fancyTextFieldWrapper = fancyTextFieldWrapper
        }

        @objc func textFieldDidChange(_ textField: UITextField) {
            fancyTextFieldWrapper.text = textField.text ?? ""
        }
    }
}

struct FancyTextField: View {
    let placeholder: String
    @Binding var text: String
    let keyboardType: UIKeyboardType
    let isSecureField: Bool
    @Binding var firstResponder: Bool

    var body: some View {
        FancyTextFieldWrapper(placeholder: placeholder, text: $text, keyboardType: keyboardType, isSecureField: isSecureField, firstResponder: $firstResponder)
            .padding()
            .background(Color.white)
            .cornerRadius(22)
    }
}
