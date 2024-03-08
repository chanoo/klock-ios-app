//
//  MyWallListHeader.swift
//  KlockApp
//
//  Created by 성찬우 on 3/7/24.
//

import SwiftUI

struct MyWallListHeader: View {
    var title: String

    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .padding([.top, .bottom], 8) // 텍스트 상하 패딩
                    .padding([.leading, .trailing], 10) // 텍스트 좌우 패딩
                    .background(FancyColor.gray9.color.opacity(0.5)) // 반투명 흰색 배경 추가
                    .cornerRadius(6) // 모서리를 둥글게 처리
                    .foregroundColor(.white) // 텍스트 색상을 흰색으로 설정
                Spacer()
            }
        }
        .upsideDown()
        .padding([.top, .bottom], 8) // VStack에 상단 패딩 추가
    }
}

#Preview {
    MyWallListHeader(title: "오늘")
}
