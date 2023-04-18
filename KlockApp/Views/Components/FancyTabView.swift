// FancyTabView.swift
// KlockApp
//
// Created by 성찬우 on 2023/04/18.
//

import SwiftUI

struct FancyTabView: View {
    @Binding var selection: Int
    let items: [(imageName: String, content: AnyView)]

    init(selection: Binding<Int>, items: [(imageName: String, content: AnyView)]) {
        self._selection = selection
        self.items = items
    }

    var body: some View {
        VStack(spacing: 0) {
            items[selection].content

            HStack(spacing: 0) {
                HStack(spacing: 0) {
                    ForEach(0..<items.count, id: \.self) { index in
                        Button(action: {
                            selection = index
                        }) {
                            FancyTabItem(imageName: items[index].imageName, isSelected: selection == index)
                        }
                    }
                }
                .padding(.horizontal)
                .frame(height: 60)
            }
            .background(FancyColor.background.color)
        }
    }
}

struct FancyTabItem: View {
    @Environment(\.colorScheme) var colorScheme
    let imageName: String
    let isSelected: Bool
    
    var body: some View {
        VStack {
            if isSelected {
                Rectangle()
                    .fill(FancyColor.primary.color)
                    .frame(height: 2)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
            }
            
            Spacer()
            
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 22, maxHeight: 22)
                .foregroundColor(isSelected ? FancyColor.primary.color : colorScheme == .dark ? .white.opacity(0.9) : .black )
            
            Spacer()
        }
    }
}
