//
//  KeyboardResponder.swift
//  KlockApp
//
//  Created by 성찬우 on 3/3/24.
//

import Foundation
import SwiftUI
import Combine

class KeyboardResponder: ObservableObject {
    @Published var isKeyboardVisible: Bool = false
    private var cancellables: Set<AnyCancellable> = []

    init() {
        let keyboardWillShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .map { _ in true }
        
        let keyboardWillHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in false }

        Publishers.Merge(keyboardWillShow, keyboardWillHide)
            .assign(to: \.isKeyboardVisible, on: self)
            .store(in: &cancellables)
    }
}
