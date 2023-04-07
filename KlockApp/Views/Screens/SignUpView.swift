//
//  SignUpView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/03.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel: SignUpViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @ViewBuilder
    var destinationView: some View {
        if viewModel.destination == .signUpTag {
            SignUpTagsView(viewModel: SignUpTagsViewModel())
        } else {
            EmptyView()
        }
    }

    var body: some View {
        ScrollView {
            VStack {
                NicknameView(viewModel: viewModel)
            }
            NavigationLink(
                destination: destinationView,
                isActive: .constant(viewModel.destination != nil),
                label: {
                    EmptyView()
                }
            )
            .onAppear {
                viewModel.resetDestination()
            }
        }
        .background(FancyColor.background.color.edgesIgnoringSafeArea(.all))
        .navigationBarTitle("닉네임", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .onAppear {
            AppState.shared.swipeEnabled = false
        }
        .onDisappear {
            AppState.shared.swipeEnabled = true
        }
    }
    
    var backButton: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(FancyColor.primary.color) // 색상을 원하는대로 변경
                Text("")
            }
        }
    }
}

struct NicknameView: View {
    @ObservedObject var viewModel: SignUpViewModel

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

                    FancyTextField(placeholder: "닉네임", text: $viewModel.nickname, keyboardType: .default)
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
        SignUpView(viewModel: SignUpViewModel())
    }
}
