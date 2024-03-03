//
//  SignUpProfileImageView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/06/05.
//

import SwiftUI
import UIKit
import Combine

struct SignUpProfileImageView: View {
    @EnvironmentObject var viewModel: SignUpViewModel
    @ObservedObject private var userProfileImageViewModel = UserProfileImageViewModel()
    @State private var activeDestination: Destination?
    @State private var cancellables = Set<AnyCancellable>()

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    BackButtonView()
                    Spacer()
                }
                .padding(.bottom, 20)
                
                Image("img_signup_step5")
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                
                Text("친구에게 보여주고픈\n나를 표현할 사진을 선택해요")
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                    .padding(.top, 30)
                    .lineSpacing(4)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                
                Text("아직 고민된다면 언제든지 설정이 가능해요")
                    .foregroundColor(.gray)
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.top, 1)

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
                    
                    if userProfileImageViewModel.isShowCemeraPermissionView {
                        Button {
                            userProfileImageViewModel.showImagePickerView()
                        } label: {
                            Image("ic_plus")
                        }
                        .padding(.top, 110)
                        .padding(.leading, 110)
                    } else {
                        NavigationLink(
                            destination: CameraPermissionView(),
                            isActive: $userProfileImageViewModel.isShowCemeraPermissionView)
                        {
                            Button {
                                userProfileImageViewModel.showCameraPermissionView()
                            } label: {
                                Image("ic_plus")
                            }
                            .padding(.top, 110)
                            .padding(.leading, 110)
                        }
                    }
                }
                .padding(.bottom, 100)

                Spacer()
                
                FancyButton(
                    title: "시작하기",
                    action: {
                        viewModel.confirmButtonTapped.send()
                    },
                    style: .constant(.black)
                )
                
                NavigationLink(
                    destination: viewForDestination(activeDestination),
                    isActive: Binding<Bool>(
                        get: { activeDestination != nil },
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

            
            if viewModel.isLoading {
                LoadingView(opacity: 0.7)
            }
        }
        .sheet(isPresented: $userProfileImageViewModel.isShowCemeraPermissionView) {
            YPImagePickerView(showingImagePicker: $userProfileImageViewModel.showingImagePicker, selectedImage: $viewModel.selectedImage)
        }
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .navigationBarHidden(true)
        .padding(.all, 30)
        .onAppear {
            subscribeToUserProfileImageViewModelChanges()
            onAppearActions()
            viewModel.onSignUpSuccess = signUpSuccess
        }
        .onReceive(viewModel.signUpSuccess, perform: { _ in
            activeDestination = .splash
        })
    }
    
    private func subscribeToUserProfileImageViewModelChanges() {
        userProfileImageViewModel.$selectedImage
            .sink { [weak viewModel] newImage in
                viewModel?.selectedImage = newImage
            }
            .store(in: &cancellables)
    }
    
    private func onAppearActions() {
        userProfileImageViewModel.checkCameraPermission()
     }
    
    private func viewForDestination(_ destination: Destination?) -> AnyView {
        switch destination {
        case .splash:
            return AnyView(SplashView())
        case .none, _:
            return AnyView(EmptyView())
        }
    }
    
    private func signUpSuccess() {
        viewModel.signUpSuccess.send()
    }
}

struct SignUpProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = Container.shared.resolve(SignUpViewModel.self)
        SignUpProfileImageView()
            .environmentObject(viewModel)
    }
}
