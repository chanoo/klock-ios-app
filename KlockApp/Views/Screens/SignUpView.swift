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
        if let destination = viewModel.destination {
            switch destination {
            case .signUpTag:
                SignUpTagsView(selectedTags: $viewModel.selectedTags, onNext: {
                    viewModel.signUp()
                    presentationMode.wrappedValue.dismiss()
                })
            default:
                EmptyView()
            }
        } else {
            EmptyView()
        }
    }

    var body: some View {
        VStack {
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
        }
    }
}

struct NicknameView: View {
    @ObservedObject var viewModel: SignUpViewModel

    var body: some View {
        VStack {
            Text("닉네임을 입력하세요")
                .font(.largeTitle)
                .padding()

            FancyTextField(placeholder: "닉네임", text: $viewModel.nickname, keyboardType: .default)
                .padding(.top, 200)

            FancyButton(title: "다음", action: {
                viewModel.nextButtonTapped.send()
            }, backgroundColor: .blue, foregroundColor: .white)
            .padding(.bottom, 20)

            Spacer()
        }
        .padding()
    }
}
