//
//  UserProfileImageView.swift
//  KlockApp
//
//  Created by 성찬우 on 12/14/23.
//

import SwiftUI
import YPImagePicker

struct UserProfileImageView: View {
    @StateObject private var viewModel = Container.shared.resolve(UserProfileImageViewModel.self)
    @Environment(\.presentationMode) var presentationMode // Add this line
    var body: some View {
        VStack {
            if viewModel.isLoading {
                Spacer()
                LoadingView()
                Spacer()
            } else {
                Spacer()
                ZStack {
                    // Your existing content
                    if let image = viewModel.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(FancyColor.profileImageBorder.color, lineWidth: 4))
                    } else {
                        ProfileImageEditView(imageURL: viewModel.userModel?.profileImage, size: 150)
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
                    error: $viewModel.error,
                    maxLength: 10,
                    firstResponder: $viewModel.nicknameTextFieldShouldBecomeFirstResponder
                )
                .padding(.top, 60)
                Spacer()
                FancyButton(
                    title: "완료",
                    action: {
                        guard self.viewModel.isNickNameButtonEnabled else { return }
                        DispatchQueue.main.async {
                            viewModel.nicknameTextFieldShouldBecomeFirstResponder = false
                        }
                        viewModel.confirmTapped.send()
                    },
                    disabled: .constant(!viewModel.isNickNameButtonEnabled),
                    style: .constant(.black)
                )
                .padding(.bottom, 20)
            }
        }
        .padding([.top, .leading, .trailing], 40)
        .navigationBarItems(leading: BackButtonView())
        .navigationBarBackButtonHidden()
        .navigationBarTitle("내 프로필 수정", displayMode: .inline)
        .onReceive(viewModel.$isLoading) { isLoading in
            if !isLoading {
                self.presentationMode.wrappedValue.dismiss() // Navigate back
            }
        }
    }
}

#Preview {
    UserProfileImageView()
}
