//
//  FriendAddDoneView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/06/15.
//

import SwiftUI

struct FriendAddDoneView: View {
    @EnvironmentObject var viewModel: FriendAddViewModel // 환경 객체로 타이머 뷰 모델을 가져옵니다.
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .center, spacing: 0) {
                Spacer()
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
                Spacer()
                ZStack(alignment: .center) {
                    LottieView(name: "lottie-confetti", currentFrame: 50)
                    Image("ic_img_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                    Text("뀨처돌이")
                        .padding(.top, 200)
                        .font(.system(size: 22, weight: .semibold))
                    
                }
                .frame(width: 300, height: 300)
                .padding(20)
                
                Spacer()
                
                FancyButton(title: "친구 프로필 보러가기", action: {
                    viewModel.activeSheet = Optional.none
                }, style: .constant(.button))
                    .padding(.top, 30)
                FancyButton(title: "계속 QR코드 스캔", action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, style: .constant(.outline))
                .padding(.top, 12)
            }
            
            HStack(spacing: 0) {
                Spacer()
                Button(action: {
                    viewModel.activeSheet = Optional.none
                }) {
                    Image("ic_xmark")
                }
            }
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
