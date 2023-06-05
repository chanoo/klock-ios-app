//
//  SignUpTagView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/06/02.
//

import SwiftUI

struct SignUpTagView: View {
    @EnvironmentObject var viewModel: SignUpViewModel

    var body: some View {
        VStack {
            HStack {
                Image("img_signup_step3")
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            
            HStack {
                Text("하루의 시작은\n언제인가요?")
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                    .padding(.top, 30)
                    .lineSpacing(4)
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            
            Text("사용할 플래너에 자동 적용되며, 언제든 변경 가능해요")
                .foregroundColor(.gray)
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.top, 1)
                .padding(.bottom, 30)

            FancyTextField(
                placeholder: "닉네임을 입력해주세요",
                text: $viewModel.signUpUserModel.username,
                keyboardType: .default,
                isSecureField: false,
                firstResponder: $viewModel.nicknameTextFieldShouldBecomeFirstResponder
            )

            Text(viewModel.error ?? "")
                .foregroundColor(.gray)
                .padding(.bottom, 30)
                .frame(maxWidth: .infinity, alignment: .topLeading)

            FancyButton(title: "다음", style: .constant(.primary))
        }
        // 왼쪽 정렬
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .padding(.all, 40)
    }


}

struct SignUpTagView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = Container.shared.resolve(SignUpViewModel.self)
        SignUpTagView()
            .environmentObject(viewModel)
    }
}
