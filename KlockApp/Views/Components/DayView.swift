//
//  DayView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/15.
//

import SwiftUI

struct DayView: View {
    let displayText: String?
    let size: CGFloat
    let backgroundColor: Color

    init(displayText: String? = nil, size: CGFloat, backgroundColor: Color) {
        self.displayText = displayText
        self.size = size
        self.backgroundColor = backgroundColor
    }

    var body: some View {
        ZStack {
            backgroundColor
            if let text = displayText {
                Text(text)
            }
        }
        .frame(width: size, height: size)
        .cornerRadius(5)
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DayView(displayText: "1", size: 50, backgroundColor: .red)
            DayView(size: 50, backgroundColor: .blue)
        }
    }
}
