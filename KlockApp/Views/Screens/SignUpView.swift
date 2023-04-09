//
//  SignUpView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/03.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel: SignUpViewModel

    var body: some View {
        ScrollView {
            VStack {
                NicknameView(viewModel: viewModel)
            }
            NavigationLink(
                destination: SignUpTagsView(viewModel: SignUpTagsViewModel(signUpUserModel: viewModel.signUpUserModel)),
                isActive: Binding<Bool>(
                    get: { viewModel.destination == .signUpTag },
                    set: { _ in viewModel.resetDestination() }
                ),
                label: {
                    EmptyView()
                }
            )
        }
        .background(FancyColor.background.color.edgesIgnoringSafeArea(.all))
        .modifier(CommonViewModifier(title: "닉네임"))
        .navigationBarItems(leading: BackButtonView())
    }
}

struct NicknameView: View {
    @ObservedObject var viewModel: SignUpViewModel

    private var combinedName: Binding<String> {
        Binding<String>(
            get: {
                "\(viewModel.signUpUserModel.lastName)\(viewModel.signUpUserModel.firstName)"
            },
            set: { newValue in
                // Do nothing (or handle the changes if needed)
            }
        )
    }

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    Text("나를 부를 수 있는 닉네임 입력하세요.")
                        .font(.system(size: 18))
                        .foregroundColor(Color.black)
                        .fontWeight(.bold)
                        .padding(.top, 32)
                        .padding(.bottom, 32)

                    FancyTextField(placeholder: "닉네임", text: combinedName, keyboardType: .default)
                        .padding(.bottom, 10)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                viewModel.nicknameTextFieldShouldBecomeFirstResponder = true
                            }
                        }

                    FancyButton(title: "다음", action: {
                        viewModel.nextButtonTapped.send()
                    }, backgroundColor: FancyColor.primary.color, foregroundColor: .white)
                    .padding(.bottom, 20)

                    Spacer()
                }
                .padding()
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(viewModel: Container.shared.resolve(SignUpViewModel.self)!)
    }
}
