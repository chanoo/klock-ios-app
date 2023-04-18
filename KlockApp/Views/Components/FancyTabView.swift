// FancyTabView.swift
// KlockApp
//
// Created by 성찬우 on 2023/04/18.
//

import SwiftUI

struct FancyTabView<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var selection: Int
    let content: Content
    let imageNames: [String]

    init(selection: Binding<Int>, imageNames: [String], @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
        self.imageNames = imageNames
    }

    private func tabButton(_ index: Int) -> some View {
        Button(action: {
            self.selection = index
        }) {
            VStack(alignment: .center, spacing: 0) {
                if selection == index {
                    Rectangle()
                        .fill(FancyColor.primary.color)
                        .frame(height: 2)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                }
                
                Spacer()
                
                Image(imageNames[index])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 24, maxHeight: 24)
                    .foregroundColor(selection == index ? FancyColor.primary.color : colorScheme == .dark ? .white.opacity(0.9) : .black)
                    
                Spacer()
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            content

            HStack(spacing: 0) {
                HStack(spacing: 0) {
                    ForEach(0..<imageNames.count, id: \.self) { index in
                        tabButton(index)
                    }
                }
                .padding(.horizontal)
                .frame(height: 60)
            }
            .background(FancyColor.background.color)
        }
    }
}
