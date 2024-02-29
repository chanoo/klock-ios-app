// FancyTabView.swift
// KlockApp
//
// Created by 성찬우 on 2023/04/18.
//

import SwiftUI
import UIKit // UIKit을 임포트해야 합니다

struct FancyTabView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var selection: Int
    @State var isTabBarVisible: Bool = true
    let items: [(selectedImageName: String?, deselectedImageName: String, content: AnyView)]

    init(selection: Binding<Int>, items: [(selectedImageName: String?, deselectedImageName: String, content: AnyView)]) {
        self._selection = selection
        self.items = items
    }

    var body: some View {
        VStack(spacing: 0) {
            items[selection].content
                .frame(height: .infinity)
            
            ZStack {
                HStack(spacing: 0) {
                    HStack(spacing: 0) {
                        ForEach(0..<items.count, id: \.self) { index in
                            Button(action: {
                                triggerHapticFeedback() // 햅틱 피드백을 트리거하는 함수 호출
                                selection = index
                            }) {
                                FancyTabItem(selectedImageName: items[index].selectedImageName,
                                             deselectedImageName: items[index].deselectedImageName,
                                             isSelected: selection == index)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .background(FancyColor.tabbarBackground.color)
                    .frame(height: isTabBarVisible ? 60 : 0)
                }
                .offset(y: isTabBarVisible ? 0 : 100)
                .opacity(isTabBarVisible ? 1.0 : 0)
                .animation(.easeInOut(duration: 0.2), value: isTabBarVisible)
            }
        }
        .onAppear {
            NotificationCenter.default.addObserver(
                forName: UIResponder.keyboardWillShowNotification,
                object: nil,
                queue: .main) { _ in
                    isTabBarVisible = false
                }
            NotificationCenter.default.addObserver(
                forName: UIResponder.keyboardWillHideNotification,
                object: nil,
                queue: .main) { _ in
                    isTabBarVisible = true
                }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(
                self,
                name: UIResponder.keyboardWillShowNotification,
                object: nil)
            NotificationCenter.default.removeObserver(
                self,
                name: UIResponder.keyboardWillHideNotification,
                object: nil)
        }
    }
    
    private func triggerHapticFeedback() {
        let impactMed = UIImpactFeedbackGenerator(style: .soft)
        impactMed.impactOccurred(intensity: 0.7)
    }
}

struct FancyTabItem: View {
    @Environment(\.colorScheme) var colorScheme
    let selectedImageName: String?
    let deselectedImageName: String
    let isSelected: Bool
    
    var body: some View {
        VStack {
            if isSelected {
                Rectangle()
                    .fill(.clear)
                    .frame(height: 2)
            } else {
                Rectangle()
                    .fill(.clear)
                    .frame(height: 1)
            }
            
            Spacer()
            
            Image(isSelected ? (selectedImageName ?? deselectedImageName) : deselectedImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 26, maxHeight: 26)
                .foregroundColor(isSelected ? FancyColor.tabbarIconSelected.color : FancyColor.tabbarIcon.color )
            
            Spacer()
        }
    }
}
