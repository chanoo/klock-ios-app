//
//  MyWallNoDataView.swift
//  KlockApp
//
//  Created by 성찬우 on 3/7/24.
//

import SwiftUI

struct MyWallNoDataView: View {
    var body: some View {
        Spacer() // Pushes content to the center vertically

        VStack {
            Image("img_chat_characters")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 79)
            Text("친구와 함께 소통하며 공부할 수 있어요!\n지금 친구를 추가해볼까요?")
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .foregroundColor(FancyColor.gray4.color)
                .font(.system(size: 13, weight: .semibold))
                .padding()
            
        }
        .frame(maxWidth: .infinity) // Ensure it takes up the full width

        Spacer() // Pushes content to the center vertically
    }
}

#Preview {
    MyWallNoDataView()
}
