//
//  FriendAddView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/06/12.
//

import SwiftUI
import Foast

struct FriendAddByQRCodeView: View {
    @ObservedObject var viewModel: FriendAddViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    switch viewModel.activeView {
                    case .scanQRCode:
                        QRCodeScannerOverlay()
                            .environmentObject(viewModel)
                            .frame(width: geometry.size.width, height: .infinity)
                    case .myQRCode:
                        NicknameView()
                            .frame(width: geometry.size.width, height: .infinity)
                            .background(.white)
                    }

                    switch viewModel.activeView {
                    case .scanQRCode:
                        Image("img_qr_guide")
                            .resizable()
                            .scaledToFill()
                            .frame(width: .infinity, height: .infinity)
                        ZStack {
                            VStack {
                                Text("QR코드를 스캔해주세요")
                                    .foregroundColor(.white)
                                    .font(.system(size: 28, weight: .bold))
                                    .padding(.top, 180)
                                    .padding(.bottom, 2)
                                Text("되도록 밝은 곳에서 스캔해주세요")
                                    .foregroundColor(.white)
                                Spacer()
                            }
                        }
                    case .myQRCode:
                        EmptyView()
                    }
                    
                    VStack(alignment: .trailing, spacing: 0) {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Image("ic_xmark")
                                .resizable()
                        }
                        .frame(width: 24, height: 24)
                        .padding(.top, 30)
                        .padding(.trailing, 20)
                        .foregroundColor(viewModel.activeView == .scanQRCode ? .white : .black)

                        HStack(alignment: .center) {
                            CustomSegmentedControl(selection: $viewModel.activeView)
                                .frame(width: 280)
                        }
                        .frame(minWidth: geometry.size.width)
                        .padding(.top, 30)

                        Spacer()
                    }
                    
                }
                .frame(width: .infinity, height: .infinity)
                .background(.black)
            }
            .navigationBarHidden(true)
        }
    }
}
struct QRCodeView: View {
    var body: some View {
        Text("QR Code Scanner")
        // 이 곳에 QR Code Scanner 기능을 추가하세요.
    }
}

struct NicknameView: View {
    @StateObject private var viewModel = Container.shared.resolve(FriendAddViewModel.self)
    @State var centerImage = UIImage(named: "ic_img_logo")
    @State private var remainingTime = 3 * 60 // 3분을 초 단위로 계산
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            Spacer()
            if let qrCodeImage = viewModel.qrCodeImage {
                Image(uiImage: qrCodeImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.top, 70)
            }
            
            // 카운트다운 텍스트
            Text("\(String(format: "%02d", remainingTime / 60)):\(String(format: "%02d", remainingTime % 60))")
                .font(.system(size: 17))
                .foregroundColor(.black)
                .padding(.top, 20)
                .onReceive(timer) { _ in
                    if remainingTime > 0 {
                        remainingTime -= 1
                    } else {
                        // 카운트다운이 0에 도달했을 때의 로직
                        viewModel.generateQRCode()
                        if let qrCodeImage = viewModel.generateQRCodeWithCenterImage() {
                            viewModel.qrCodeImage = qrCodeImage
                        }
                        remainingTime = 3 * 60 // 카운트다운을 다시 3분으로 재설정
                    }
                }
                        
            HStack(alignment: .center) {
                Button {
                    viewModel.generateQRCode()
                    if let qrCodeImage = viewModel.generateQRCodeWithCenterImage() {
                        viewModel.qrCodeImage = qrCodeImage
                    }
                    remainingTime = 3 * 60 // 카운트다운을 다시 3분으로 재설정
                } label: {
                    Image("ic_refresh")
                        .foregroundColor(.black)
                }
                
//                Spacer()
//
//                Button {
//                    Foast.show(message: "QR코드 저장")
//                } label: {
//                    Image("ic_download")
//                        .foregroundColor(.black)
//                }
//
//                Spacer()
//
//                Button {
//                    Foast.show(message: "QR코드 공유")
//                } label: {
//                    Image("ic_share")
//                        .foregroundColor(.black)
//                }

            }
            .frame(maxWidth: 180)
            .padding(.top, 30)

            Text("상단의 QR 코드를 친구가 인식하면\n서로를 팔로우 할 수 있어요")
                .foregroundColor(FancyColor.gray4.color)
                .font(.system(size: 15, weight: .semibold))
                .multilineTextAlignment(.center)
                .lineSpacing(10)
                .padding(.top, 60)
            Spacer()
        }
        .onAppear {
            viewModel.generateQRCode()
            viewModel.centerImage = centerImage
            if let qrCodeImage = viewModel.generateQRCodeWithCenterImage() {
                viewModel.qrCodeImage = qrCodeImage
            }
        }

    }
}

struct FriendAddView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = Container.shared.resolve(FriendAddViewModel.self)
        FriendAddByQRCodeView(viewModel: viewModel)
    }
}

