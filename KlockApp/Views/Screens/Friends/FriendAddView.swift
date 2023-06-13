//
//  FriendAddView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/06/12.
//

import SwiftUI

struct FriendAddView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var viewModel = Container.shared.resolve(FriendAddViewModel.self)
    @StateObject private var qrCodeScannerViewModel = Container.shared.resolve(QRCodeScannerViewModel.self)

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                switch viewModel.activeView {
                case .qrCode:
                    QRCodeScannerView(viewModel: qrCodeScannerViewModel)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .edgesIgnoringSafeArea(.all)
                case .nickname:
                    NicknameView()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .background(.red)
                }

                switch viewModel.activeView {
                case .qrCode:
                    Image("img_qr_guide")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                    ZStack {
                        VStack {
                            Text("QR 코드를 스캔해주세요")
                                .foregroundColor(.white)
                                .font(.system(size: 28, weight: .bold))
                                .padding(.top, 190)
                                .padding(.bottom, 2)
                            Text("되도록 밝은 곳에서 스캔해주세요")
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }
                case .nickname:
                    EmptyView()
                }
                
                VStack(alignment: .leading) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("ic_chevron_left")
                    }
                    .padding(.top, 8)
                    .padding(.leading, 12)
                    .foregroundColor(.white)

                    HStack(alignment: .center) {
                        CustomSegmentedControl(selection: $viewModel.activeView)
                            .frame(width: 280)
                    }
                    .frame(minWidth: geometry.size.width)
                    .padding(.top, 50)

                    Spacer()
                }
                
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(.black)
        }
        .navigationBarHidden(true)
    }
}
struct QRCodeView: View {
    var body: some View {
        Text("QR Code Scanner")
        // 이 곳에 QR Code Scanner 기능을 추가하세요.
    }
}

struct NicknameView: View {
    var body: some View {
        Text("Nickname Input")
        // 이 곳에 닉네임을 입력하여 친구를 추가하는 기능을 추가하세요.
    }
}


struct FriendAddView_Previews: PreviewProvider {
    static var previews: some View {
        FriendAddView()
    }
}

