//
//  MyWallNoDataView.swift
//  KlockApp
//
//  Created by 성찬우 on 3/7/24.
//

import SwiftUI

struct MyWallNoDataView: View {
    let message: String
    var body: some View {
        Spacer() // Pushes content to the center vertically

        VStack {
            Image("img_chat_characters")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 79)
            Text(message)
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
    MyWallNoDataView(message: "친구의 담벼락이 아직 비어 있네요.\n첫 메시지를 남겨보며 친구와의 소통을 시작해보세요!")
}
