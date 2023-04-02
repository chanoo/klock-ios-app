//
//  FancyButton.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/03/31.
//

import SwiftUI

struct FancyButton: View {
    let title: String
    let action: () -> Void
    let backgroundColor: Color
    let foregroundColor: Color
    let icon: Image? = nil
    let isBlock: Bool = true

    var body: some View {
        Button(action: action) {
            HStack {
                if let icon = icon {
                    icon
                        .foregroundColor(foregroundColor)
                        .padding(.trailing, 5)
                }
                Text(title)
                    .foregroundColor(foregroundColor)
            }
            .padding()
            .frame(maxWidth: isBlock ? .infinity : nil)
            .background(backgroundColor)
            .cornerRadius(5)
        }
    }
}
