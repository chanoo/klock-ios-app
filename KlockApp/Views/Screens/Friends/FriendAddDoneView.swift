//
//  FriendAddDoneView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/06/15.
//

import SwiftUI

struct FriendAddDoneView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("함께 성장할\n새 친구가 생겼어요!")
                        .lineSpacing(6)
                        .font(.system(size: 24, weight: .semibold))
                    Spacer()
                }
                HStack {
                    Text("친구의 프로필에 들러 응원해보세요")
                        .foregroundColor(FancyColor.gray4.color)
                        .padding(.top, 18)
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 80)
            
            Spacer()
            
            ZStack(alignment: .center) {
                LottieView(name: "lottie-confetti", currentFrame: 50)
                Image("ic_img_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
            }
            .frame(width: 300, height: 300)
            .padding(20)
            
            Spacer()
            
            FancyButton(title: "친구 프로필 보러가기", style: .constant(.button))
                .padding(.top, 30)
        }
        .padding(30)
        .frame(width: .infinity, height: .infinity)
        .navigationBarHidden(true)
    }
}

struct FriendAddDoneView_Previews: PreviewProvider {
    static var previews: some View {
        FriendAddDoneView()
    }
}
