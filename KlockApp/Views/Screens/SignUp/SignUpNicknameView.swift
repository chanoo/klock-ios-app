//
//  SignUpNicknameView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/06/01.
//

import SwiftUI

struct SignUpNicknameView: View {
    @EnvironmentObject var viewModel: SignUpViewModel
    @State private var activeDestination: Destination?

    var body: some View {
        VStack {
            HStack {
                Image("img_signup_step1")
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            
            HStack {
                Text("어떤 닉네임으로\n스터디 해볼까요?")
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                    .padding(.top, 30)
                    .lineSpacing(4)
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            
            Text("열 글자 이내로 닉네임을 지어보세요")
                .foregroundColor(.gray)
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.top, 1)
                .padding(.bottom, 30)

            FancyTextField(
                placeholder: "닉네임을 입력해주세요",
                text: $viewModel.signUpUserModel.username,
                isValid: viewModel.isNextButtonEnabled,
                firstResponder: $viewModel.nicknameTextFieldShouldBecomeFirstResponder
            )

            Text(viewModel.error ?? "")
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            
            Spacer()

            FancyButton(
                title: "다음",
                action: {
                    DispatchQueue.main.async {
                        viewModel.nicknameTextFieldShouldBecomeFirstResponder = false
                    }
                    activeDestination = .signUpStartOfWeek
                },
                disabled: !viewModel.isNextButtonEnabled,
                style: .constant(.button)
            )

            NavigationLink(
                destination: viewForDestination(activeDestination),
                isActive: Binding<Bool>(
                    get: { activeDestination == .signUpStartOfWeek },
                    set: { newValue in
                        if !newValue {
                            activeDestination = nil
                        }
                    }
                ),
                label: {
                    EmptyView()
                }
            )
            .hidden()
        }
        // 왼쪽 정렬
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .padding(.all, 40)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                viewModel.nicknameTextFieldShouldBecomeFirstResponder = true
            }
        }
        .onChange(of: viewModel.signUpUserModel.username) { newValue in
            viewModel.isNextButtonEnabled = newValue.count >= 2
        }
    }
    
    private func viewForDestination(_ destination: Destination?) -> AnyView {
         switch destination {
         case .signUpStartOfWeek:
             return AnyView(SignUpStartWeekView().environmentObject(viewModel))
         case .none, _:
             return AnyView(EmptyView())
         }
     }
}

struct SignUpNicknameView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = Container.shared.resolve(SignUpViewModel.self)
        SignUpNicknameView()
            .environmentObject(viewModel)
    }
}
