//
//  ChatInputView.swift
//  KlockApp
//
//  Created by 성찬우 on 2/17/24.
//

import SwiftUI

struct ChatInputView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var tabBarManager: TabBarManager

    @Binding var text: String
    @Binding var dynamicHeight: CGFloat
    @Binding var isPreparingResponse: Bool
    @Binding var selectedImage: UIImage?
    @Binding var cameraPermissionGranted: Bool
    @Binding var showingImagePicker: Bool
    @Binding var isSendMessage: Bool
    let onSend: (String) -> Void // 클로저 추가
    let maxHeight: CGFloat = 70 // 최대 높이 (1줄당 대략 20~25 정도를 예상하고 세팅)

    @State var isShowCemeraPermissionView: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            if let uiImage = selectedImage {
                ScrollView(.horizontal) {
                    HStack {
                        ImageViewWithDeleteButton(uiImage: uiImage, action: {
                            selectedImage = nil
                        })
                        .padding(.leading, 16)
                        .padding(.top, 12)
                    }
                }
                .padding(10)
                .padding([.leading, .trailing], 16)
            }

            HStack(alignment: .bottom, spacing: 0) {
                if cameraPermissionGranted {
                    Button(action: {
                        DispatchQueue.main.async {
                            self.showingImagePicker = true
                        }
                    }) {
                        Image("ic_picture")
                            .foregroundColor(FancyColor.chatBotUploadButton.color)
                            .padding(10)
                    }
                    .frame(width: 30, height: 30)
                    .padding(.trailing, 12)
                    .padding(.bottom, 4)
                    .sheet(isPresented: $showingImagePicker) {
                        YPImagePickerView(showingImagePicker: $showingImagePicker, selectedImage: $selectedImage)
                    }
                } else {
                    NavigationLink(
                        destination: CameraPermissionView(),
                        isActive: $isShowCemeraPermissionView)
                    {
                        Button {
                            isShowCemeraPermissionView = true
                        } label: {
                            Image("ic_picture")
                                .foregroundColor(FancyColor.chatBotUploadButton.color)
                                .padding(10)
                        }
                        .frame(width: 30, height: 30)
                        .padding(.trailing, 12)
                        .padding(.bottom, 4)
                    }
                }
                
                ZStack(alignment: .bottomTrailing) {
                    TextView(text: $text, dynamicHeight: $dynamicHeight, maxHeight: maxHeight)
                        .frame(height: dynamicHeight)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(0)
                        .padding(.leading, 6)
                        .padding(.trailing, 25)
                        .foregroundColor(FancyColor.primary.color)
                        .background(FancyColor.chatBotInput.color)
                        .cornerRadius(4)
                }
                .padding(1)
                .background(FancyColor.chatBotInputOutline.color)
                .cornerRadius(4)
                .padding(.top, 2)

                Button(action: {
                    if !isSendMessage && (!text.isEmpty || selectedImage != nil) {
                        onSend(text) // 버튼을 눌렀을 때 클로저 실행
                        withAnimation(Animation.linear(duration: 0.2)) {
                            dynamicHeight = 36
                        }
                        text = ""
                    }
                }) {
                    if isSendMessage {
                        if colorScheme == .dark {
                            LottieView(name: "lottie-circle-loading-dark", speed: 1.0)
                                .frame(width: 42, height: 42)
                        } else {
                            LottieView(name: "lottie-circle-loading-light", speed: 1.0)
                                .frame(width: 42, height: 42)
                        }
                    } else {
                        Image("ic_circle_arrow_up")
                            .foregroundColor(FancyColor.chatBotSendButton.color)
                    }
                }
                .padding(1)
                .padding(.top, 2)
                .frame(height: 40)
                .frame(width: 40)
                .disabled(isPreparingResponse)
            }
            .padding(.top, 5)
            .padding(.leading, 14)
            .padding(.trailing, 8)
            .padding(.bottom, 8)
        }
        .background(FancyColor.chatBotInputBackground.color)
    }
}

struct ImageViewWithDeleteButton: View {
    let uiImage: UIImage
    let action: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 120)
                .cornerRadius(8)
            
            Button(action: action) {
                Image("ic_circle_cross_o")
                    .foregroundColor(.red)
                    .background(Color.white.opacity(0.6))
                    .clipShape(Circle())
            }
            .offset(x: 10, y: -10) // 위치 조절이 필요할 경우
        }
    }
}


struct ChatInputView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ChatInputView(
                text: .constant(""),
                dynamicHeight: .constant(36),
                isPreparingResponse: .constant(false),
                selectedImage: .constant(UIImage(named: "ic_picture")),
                cameraPermissionGranted: .constant(false),
                showingImagePicker: .constant(false),
                isSendMessage: .constant(false),
                onSend: { _ in })
                .padding(.bottom, 0)
        }
    }
}
