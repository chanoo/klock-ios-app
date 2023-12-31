//
//  ProfileImageView.swift
//  KlockApp
//
//  Created by 성찬우 on 12/31/23.
//

import SwiftUI

struct ProfileImageEditView: View {
    let imageURL: String?
    let size: CGFloat

    var body: some View {
        ProfileImageView(imageURL: imageURL, size: size)
            .overlay(Circle().stroke(FancyColor.profileImageBorder.color, lineWidth: 4))
            .frame(width: size, height: size)
    }
}


#Preview {
    ProfileImageEditView(imageURL: "https://resource.klock.app/user-profile/c38f59f2-0f9a-49de-a408-f2257c4642ac.png", size: 150)
}
