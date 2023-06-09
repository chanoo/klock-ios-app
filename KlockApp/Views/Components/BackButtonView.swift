//
//  BackButtonView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/07.
//

import SwiftUI

struct BackButtonView: View {
    @Environment(\.presentationMode) var presentationMode
    let action: (() -> Void)?

    init(action: (() -> Void)? = nil) {
        self.action = action
    }

    var body: some View {
        Button(action: {
            action?() ?? presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(FancyColor.backButton.color)
                Text("")
            }
        }
    }
}
