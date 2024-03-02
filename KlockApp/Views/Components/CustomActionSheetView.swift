//
//  CustomActionSheetView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/06/28.
//

import SwiftUI

struct CustomActionSheetView: View {
    @EnvironmentObject var tabBarManager: TabBarManager
    @State private var keyboardHeight: CGFloat = 0
    
    let title: String
    var message: String? = nil
    var content: AnyView? = nil
    let actionButtons: [FancyButton]?
    let cancelButton: FancyButton

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 0) {
                    Spacer()

                    VStack(alignment: .leading, spacing: 0) {
                        Text(title)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(Color("color_text"))
                            .padding([.leading, .trailing], 10)
                            .padding([.bottom], 5)
                            .padding([.top], 60)

                        if let message = message {
                            Text(message)
                                .font(.system(size: 15))
                                .foregroundColor(Color("color_subtext"))
                                .padding([.leading, .trailing], 10)
                                .padding([.bottom], 20)
                                .padding([.top], 5)
                        }
                        
                        if let content = content {
                            content
                                .frame(width: geometry.size.width - 40, height: .infinity)
                        }

                        if let actionButtons = actionButtons {
                            ForEach(actionButtons.indices, id: \.self) { index in
                                actionButtons[index]
                                    .frame(width: geometry.size.width - 40, height: 60)
                                    .padding([.top, .bottom], 4)
                            }
                        }

                        cancelButton
                            .frame(width: geometry.size.width - 40, height: 60)
                            .padding([.top, .bottom], 12)
                    }
                    .padding(.bottom, 36 + keyboardHeight) // Adjust padding based on keyboard height
                    .padding(.bottom, geometry.safeAreaInsets.bottom)
                    .frame(width: geometry.size.width)
                    .background(RoundedCorner(radius: 20, corners: [.topLeft, .topRight]).fill(FancyColor.actionsheetBackground.color))
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            self.addKeyboardObservers()
        }
        .onDisappear {
            self.removeKeyboardObservers()
        }
    }
    
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notification) in
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            self.keyboardHeight = keyboardFrame.height
        }

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            self.keyboardHeight = 0
        }
    }

    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
