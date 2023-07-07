//
//  SignUpProfileImageView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/06/05.
//

import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var selectedImage: UIImage?
        @Environment(\.presentationMode) var presentationMode

        init(selectedImage: Binding<UIImage?>) {
            _selectedImage = selectedImage
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                selectedImage = uiImage
            }
            presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.wrappedValue.dismiss()
        }
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(selectedImage: $selectedImage)
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
}


struct SignUpProfileImageView: View {
    @EnvironmentObject var viewModel: SignUpViewModel
    @State private var selectedDay: FirstDayOfWeek = .sunday
    @State private var activeDestination: Destination?
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary

    var body: some View {
        VStack {
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
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                } else {
                    Image("img_profile")
                }
                
                Button {
                    showActionSheet()
                } label: {
                    Image("ic_plus")
                }
                .padding(.top, 110)
                .padding(.leading, 110)
            }

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
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .navigationBarItems(leading: BackButtonView())
        .navigationBarBackButtonHidden()
        .padding(.all, 30)
        .onAppear {
            viewModel.onSignUpSuccess = signUpSuccess
        }
        .onReceive(viewModel.signUpSuccess, perform: { _ in
            activeDestination = .splash
        })
    }
    
    private func viewForDestination(_ destination: Destination?) -> AnyView {
        switch destination {
        case .splash:
            return AnyView(SplashView())
        case .none, _:
            return AnyView(EmptyView())
        }
    }
    
    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default) { _ in
            self.sourceType = .camera
            self.isShowingImagePicker = true
        })
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default) { _ in
            self.sourceType = .photoLibrary
            self.isShowingImagePicker = true
        })
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if let controller = UIApplication.shared.windows.first?.rootViewController {
            controller.present(actionSheet, animated: true)
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
