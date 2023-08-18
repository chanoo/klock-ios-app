//
//  CameraPermissionView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/09/02.
//

import SwiftUI

struct CameraPermissionView: View {
    @StateObject var viewModel = CameraPermissionViewModel()
    @EnvironmentObject var actionSheetManager: ActionSheetManager
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .center, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("권한 허용이\n필요한 기능이에요.")
                            .lineSpacing(6)
                            .font(.system(size: 24, weight: .semibold))
                        Spacer()
                    }
                    HStack {
                        Text("더 유용한 기능을 사용해 설장해 보세요.")
                            .foregroundColor(FancyColor.gray4.color)
                            .padding(.top, 18)
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 80)

                Spacer()

                ZStack(alignment: .center) {
                    Image("img_character_question_marks")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)                   
                }
                .frame(width: 300, height: 300)
                .padding(20)
                
                Spacer()
                
                permissionButton
            }
            .padding(30)
        }
        .withoutAnimation()
        .frame(width: .infinity, height: .infinity)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: BackButtonView()
        )
        .onAppear(perform: onAppearActions)
        .onReceive(viewModel.$cameraPermissionGranted) { status in
            if status {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private var permissionButton: some View {
        switch viewModel.cameraPermissionStatus {
        case .authorized:
            return FancyButton(title: "Ai자동 타이머로 가기", action: {
                self.presentationMode.wrappedValue.dismiss()
            }, style: .constant(.black))
                .padding(.top, 30)
        case .notDetermined:
            return FancyButton(title: "권한 요청", action: {
                viewModel.requestCameraPermission()
            }, style: .constant(.black))
                .padding(.top, 30)
        default:
            return FancyButton(title: "앱 설정으로 이동", action: {
                viewModel.openAppSettings()
            }, style: .constant(.black))
                .padding(.top, 30)
        }
    }
    
    private func onAppearActions() {
        viewModel.checkCameraPermission()
        if viewModel.cameraPermissionStatus != .authorized && viewModel.cameraPermissionStatus != .notDetermined {
            alertSheet()
        }
     }
    
    private func alertSheet() {
        actionSheetManager.actionSheet = CustomActionSheetView(
            title: "카메라를 사용할 수 없습니다.",
            message: "카메라 사용을 원하시면 휴대폰 설정에서 클라크의 카메라 접근 권한을 허용해 주세요.",
            actionButtons: [
                ActionButton(title: "설정하러 가기", action: {
                    viewModel.openAppSettings()
                    actionSheetManager.hide()
                }),
            ],
            cancelButton: ActionButton(title: "취소", action: {
                actionSheetManager.hide()
            })
        )

        withAnimation {
            actionSheetManager.show()
        }
    }
}

struct CameraPermissionView_Previews: PreviewProvider {
    static var previews: some View {
        CameraPermissionView()
    }
}
