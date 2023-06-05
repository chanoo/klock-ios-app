//
//  SignUpView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/03.
//

import SwiftUI

struct SignUpUsernameView: View {

    @EnvironmentObject var viewModel: SignUpViewModel
    @State private var activeDestination: Destination?

    var body: some View {
        ZStack {
            FancyColor.background.color.edgesIgnoringSafeArea(.all)

            VStack {
                NicknameView(viewModel: viewModel)
            }
            .modifier(CommonViewModifier(title: "닉네임"))
            .navigationBarItems(leading: BackButtonView())
            .onAppear {
                viewModel.onUsernameNextButtonTapped = signInSuccessful
            }
            .background(
                NavigationLink(
                    destination: viewForDestination(activeDestination),
                    isActive: Binding<Bool>(
                        get: { activeDestination == .signUpTags },
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
                .opacity(0)
            )
        }
    }

    private func viewForDestination(_ destination: Destination?) -> AnyView {
         switch destination {
         case .signUpTags:
             return AnyView(SignUpTagsView().environmentObject(viewModel))
         case .none, _:
             return AnyView(EmptyView())
         }
     }

    private func signInSuccessful() {
        activeDestination = .signUpTags
    }
}

struct NicknameView: View {

    @StateObject var viewModel: SignUpViewModel
    @EnvironmentObject var signUpUserModel: SignUpUserModel

    var body: some View {
        VStack {
            VStack {
                Text("나를 부를 수 있는 닉네임 입력하세요.")
                    .font(.system(size: 18))
                    .foregroundColor(Color.black)
                    .fontWeight(.bold)
                    .padding(.top, 32)
                    .padding(.bottom, 32)

                FancyTextField(
                    placeholder: "닉네임",
                    text: $viewModel.signUpUserModel.username,
                    keyboardType: .default,
                    isSecureField: false,
                    firstResponder: $viewModel.nicknameTextFieldShouldBecomeFirstResponder,
                    onCommit: {
                        viewModel.nextButtonTapped.send()
                    })
                    .padding(.bottom, 10)
                    .onAppear {
                        viewModel.signUpUserModel = signUpUserModel
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            viewModel.nicknameTextFieldShouldBecomeFirstResponder = true
                        }
                    }
                    .onChange(of: viewModel.signUpUserModel.username) { newValue in
                        viewModel.isNextButtonEnabled = newValue.count >= 2
                    }

                FancyButton(title: "다음", action: {
                    DispatchQueue.main.async {
                        viewModel.nicknameTextFieldShouldBecomeFirstResponder = false
                    }
                    viewModel.nextButtonTapped.send()
                }, style: .constant(.primary))
                .disabled(!viewModel.isNextButtonEnabled)
                .opacity(viewModel.isNextButtonEnabled ? 1 : 0.5)
                .padding(.bottom, 20)

                Spacer()
            }
            .padding()
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = Container.shared.resolve(SignUpViewModel.self)
        SignUpUsernameView()
            .environmentObject(viewModel)
            .environmentObject(AppFlowManager())
    }
}
