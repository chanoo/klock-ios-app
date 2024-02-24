//
//  ProfileImageView.swift
//  KlockApp
//
//  Created by 성찬우 on 12/31/23.
//

import SwiftUI
import CachedAsyncImage

struct ProfileImageView: View {
    let imageURL: String?
    let size: CGFloat

    var body: some View {
        Group {
            if let urlString = imageURL, let url = URL(string: urlString) {
                CachedAsyncImage(url: url, urlCache: .imageCache) { phase in
                    switch phase {
                    case .empty, .failure(_):
                        DefaultProfileImage(size: size)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .scaledToFit()
                    @unknown default:
                        DefaultProfileImage(size: size)
                    }
                }
            } else {
                DefaultProfileImage(size: size)
            }
        }
        .clipShape(Circle())
        .frame(width: size, height: size)
    }
}

struct ProfileImageWrapperView: View {
    var profileImageURL: String?
    var profileImageSize: CGFloat = 44

    var body: some View {
        if let url = profileImageURL, url.starts(with: "http") {
            ProfileImageView(imageURL: url, size: profileImageSize)
        } else if let imageName = profileImageURL {
            Image(imageName)
                .cornerRadius(22.0)
        } else {
            DefaultProfileImage(size: profileImageSize)
        }
    }
}

struct DefaultProfileImage: View {
    let size: CGFloat

    var body: some View {
        Image("img_profile")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(Circle())
            .frame(width: size, height: size)
    }
}


#Preview {
    ProfileImageView(imageURL: "https://resource.klock.app/user-profile/c38f59f2-0f9a-49de-a408-f2257c4642ac.png", size: 150)
}
