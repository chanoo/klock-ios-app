//
//  FlowStack.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/07.
//

import SwiftUI

struct FlowHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct FlowStack<Content: View>: View {
    let items: [TagModel]
    let spacing: CGFloat
    let content: (TagModel) -> Content

    init(items: [TagModel], spacing: CGFloat, content: @escaping (TagModel) -> Content) {
        self.items = items
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            ForEach(items) { item in
                GeometryReader { geometry in
                    content(item)
                        .fixedSize(horizontal: true, vertical: false)
                        .alignmentGuide(.leading) { _ in spacing }
                        .background(GeometryReader { innerGeometry in
                            Color.clear
                                .preference(key: FlowHeightPreferenceKey.self, value: innerGeometry.frame(in: .global).maxY)
                        })
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
