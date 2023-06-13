//
//  CustomSegmentedControl.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/06/13.
//

import SwiftUI

struct CustomSegmentedControl: View {
    @Binding var selection: ActiveView

    var body: some View {
        HStack {
            Button(action: {
                selection = .qrCode
            }) {
                Text("QR코드 스캔")
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 15, weight: .semibold))
                    .background(selection == .qrCode ? .white : Color.clear)
                    .foregroundColor(selection == .qrCode ? .black : .white)
            }
            .cornerRadius(4)
            .padding(10)
            Button(action: {
                selection = .nickname
            }) {
                Text("닉네임 입력")
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 15, weight: .semibold))
                    .background(selection == .nickname ? .white : Color.clear)
                    .foregroundColor(selection == .nickname ? .black : .white)
            }
            .cornerRadius(4)
            .padding(10)
        }
        .background(FancyColor.black.color.opacity(0.3))
        .cornerRadius(6)
    }
}

//struct CustomSegmentedControl_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomSegmentedControl(selection: .qrCode)
//    }
//}
