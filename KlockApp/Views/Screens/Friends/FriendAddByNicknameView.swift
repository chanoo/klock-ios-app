//
//  FriendAddByNicknameView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/06/12.
//

import SwiftUI

struct FriendAddByNicknameView: View {
    @EnvironmentObject var viewModel: FriendAddViewModel // 환경 객체로 타이머 뷰 모델을 가져옵니다.
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                VStack(alignment: .center, spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("친구의 닉네임을\n입력하세요")
                                .lineSpacing(6)
                                .font(.system(size: 24, weight: .semibold))
                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 80)
                    
                    FancyTextField(
                        placeholder: "친구의 닉네임을 입력해주세요",
                        text: $viewModel.nickname,
                        isValid: viewModel.isStartOfWeekNextButtonEnabled,
                        firstResponder: $viewModel.becomeFirstResponder
                    )
                    .padding(.top, 40)

                    Spacer()
                    
                    NavigationLink(
                        destination: FriendAddDoneView().environmentObject(viewModel),
                        isActive: $viewModel.isNavigatingToNextView) {
                            FancyButton(
                                title: "다음",
                                action: {
                                    DispatchQueue.main.async {
                                        viewModel.becomeFirstResponder = false
                                        viewModel.isNavigatingToNextView = true
                                    }
                                },
                                disabled: .constant(!viewModel.isStartOfWeekNextButtonEnabled),
                                style: .constant(.button)
                            )
                    }
                }
                
                HStack(spacing: 0) {
                    Spacer()
                    Button(action: {
                        viewModel.isNavigatingToNextView = true
                    }) {
                        Image("ic_xmark")
                    }
                }
            }
            .padding(30)
            .frame(width: .infinity, height: .infinity)
            .navigationBarHidden(true)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    viewModel.becomeFirstResponder = true
                }
            }
        }
    }
}

struct FriendAddByNicknameView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = Container.shared.resolve(FriendAddViewModel.self)
        FriendAddByNicknameView()
            .environmentObject(viewModel)
    }
}
