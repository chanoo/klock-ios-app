//
//  CustomActionSheetModifier.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/06/28.
//

import SwiftUI

struct CustomActionSheetModifier: ViewModifier {
    @Binding var isPresented: Bool
    let content: () -> AnyView

    func body(content: Content) -> some View {
        ZStack {
            content
            Color.black.opacity(isPresented ? 0.5 : 0.0)
                .edgesIgnoringSafeArea(.all)
            self.content()
                .modifier(SlideUpTransition(isPresented: isPresented))
        }
    }
}
