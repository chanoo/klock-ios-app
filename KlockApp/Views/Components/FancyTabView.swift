// FancyTabView.swift
// KlockApp
//
// Created by 성찬우 on 2023/04/18.
//

import SwiftUI

struct FancyTabView: View {
    @EnvironmentObject var tabBarManager: TabBarManager
    @Environment(\.colorScheme) var colorScheme
    @Binding var selection: Int
    @StateObject private var keyboardResponder = KeyboardResponder() // 키보드 상태 관찰 객체
    let items: [(selectedImageName: String?, deselectedImageName: String, content: () -> AnyView)]

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                ForEach(0..<items.count, id: \.self) { index in
                    if selection == index {
                        items[index].content()
                            .frame(maxHeight: .infinity)
                    }
                }
            }
            
            if !keyboardResponder.isKeyboardVisible {
                if tabBarManager.isTabBarVisible {
                    HStack(spacing: 0) {
                        ForEach(0..<items.count, id: \.self) { index in
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    triggerHapticFeedback()
                                    selection = index
                                }
                            }) {
                                FancyTabItem(selectedImageName: items[index].selectedImageName,
                                             deselectedImageName: items[index].deselectedImageName,
                                             isSelected: selection == index)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .background(tabBarManager.isTabBarVisible ? FancyColor.tabbarBackground.color : FancyColor.background.color)
                    .frame(height: tabBarManager.isTabBarVisible ? 60 : 0)
                    .transition(.move(edge: .bottom))
                }
            }
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
