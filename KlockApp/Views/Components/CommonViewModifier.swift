//
//  CommonViewModifier.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/07.
//

import SwiftUI

struct CommonViewModifier: ViewModifier {
    let title: String

    func body(content: Content) -> some View {
        content
            .navigationBarTitle(title, displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                AppState.shared.swipeEnabled = false
            }
            .onDisappear {
                AppState.shared.swipeEnabled = true
            }
    }
}
