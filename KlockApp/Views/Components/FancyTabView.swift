// FancyTabView.swift
// KlockApp
//
// Created by 성찬우 on 2023/04/18.
//

import SwiftUI

struct FancyTabView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var tabBarManager: TabBarManager
    @Binding var selection: Int
    let items: [(selectedImageName: String?, deselectedImageName: String, content: AnyView)]

    init(selection: Binding<Int>, items: [(selectedImageName: String?, deselectedImageName: String, content: AnyView)]) {
        self._selection = selection
        self.items = items
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                items[selection].content
                    .frame(height: .infinity) // 추가
                
                ZStack {
                    HStack(spacing: 0) {
                        HStack(spacing: 0) {
                            ForEach(0..<items.count, id: \.self) { index in
                                Button(action: {
                                    selection = index
                                }) {
                                    FancyTabItem(selectedImageName: items[index].selectedImageName,
                                                 deselectedImageName: items[index].deselectedImageName,
                                                 isSelected: selection == index)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .background(FancyColor.navigationBar.color)
                        .frame(height: tabBarManager.isTabBarVisible ? 60 : 0)
                    }
                    .offset(y: tabBarManager.isTabBarVisible ? 0 : 100)
                    .opacity(tabBarManager.isTabBarVisible ? 1.0 : 0)
                    .animation(.easeInOut(duration: 0.5), value: tabBarManager.isTabBarVisible)
                }
            }
        }
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
