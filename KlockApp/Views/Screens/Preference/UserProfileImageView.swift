//
//  UserProfileImageView.swift
//  KlockApp
//
//  Created by 성찬우 on 12/14/23.
//

import SwiftUI
import YPImagePicker

struct UserProfileImageView: View {
    @StateObject private var viewModel = UserProfileImageViewModel()

    var body: some View {
        VStack {
            Spacer()
            ZStack {
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(FancyColor.black.color, lineWidth: 4))
                } else {
                    Image("img_profile")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(FancyColor.black.color, lineWidth: 4))
                }
                
                Button(action: {
                    viewModel.showImagePickerView()
                }) {
                    Image("ic_plus")
                }
                .padding(.top, 110)
                .padding(.leading, 110)
                .sheet(isPresented: $viewModel.showingImagePicker) {
                    YPImagePickerView(showingImagePicker: $viewModel.showingImagePicker, selectedImage: $viewModel.selectedImage)
                }
            }
            FancyTextField(
                placeholder: "닉네임을 입력해주세요",
                text: $viewModel.nickname,
                isValid: viewModel.isNickNameButtonEnabled,
                maxLength: 10,
                firstResponder: $viewModel.nicknameTextFieldShouldBecomeFirstResponder
            )
            .padding(.top, 70)
            Spacer()
            FancyButton(
                title: "완료",
                action: {
                    guard self.viewModel.isNickNameButtonEnabled else { return }
                    DispatchQueue.main.async {
                        viewModel.nicknameTextFieldShouldBecomeFirstResponder = false
                    }
                },
                disabled: .constant(!viewModel.isNickNameButtonEnabled),
                style: .constant(.black)
            )
        }
        .padding(.all, 40)
        .navigationBarItems(leading: BackButtonView())
        .navigationBarBackButtonHidden()
        .navigationBarTitle("내 프로필 수정", displayMode: .inline)
    }
}

#Preview {
    UserProfileImageView()
}
