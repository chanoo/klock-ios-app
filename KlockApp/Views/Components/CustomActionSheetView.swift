//
//  CustomActionSheetView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/06/28.
//

import SwiftUI

struct ActionButton {
    var label: Text
    var action: () -> Void
}

struct CustomActionSheetView: View {
    let title: String
    let message: String
    let actionButtons: [ActionButton]
    let cancelButton: ActionButton

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

                        Text(message)
                            .font(.system(size: 15))
                            .foregroundColor(Color("color_subtext"))
                            .padding([.leading, .trailing], 10)
                            .padding([.bottom], 20)
                            .padding([.top], 5)

                        ForEach(actionButtons.indices, id: \.self) { index in
                            Button(action: {
                                actionButtons[index].action()
                            }) {
                                actionButtons[index].label
                                    .frame(width: geometry.size.width - 40, height: 60)
                                    .font(.system(size: 17))
                                    .background(FancyColor.button.color)
                                    .foregroundColor(.white)
                                    .cornerRadius(6)
                            }
                            .contentShape(Rectangle())
                            .padding([.top, .bottom], 4)
                        }

                        Button(action: {
                            cancelButton.action()
                        }) {
                            cancelButton.label
                                .frame(width: geometry.size.width - 40, height: 60)
                                .font(.system(size: 17))
                                .background(FancyColor.buttonCancel.color)
                                .foregroundColor(FancyColor.text.color)
                                .cornerRadius(6)
                        }
                        .contentShape(Rectangle())
                        .padding([.top, .bottom], 12)
                    }
                    .padding(.bottom, 36)
                    .padding(.bottom, geometry.safeAreaInsets.bottom)
                    .frame(width: geometry.size.width)
                    .background(RoundedCorner(radius: 20, corners: [.topLeft, .topRight]).fill(FancyColor.actionsheetBackground.color))
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
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
