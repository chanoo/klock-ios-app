//
//  ActivityModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/06/21.
//

import Combine

class ActivityModel: ObservableObject {
    let id: Int64?
    let message: String
    let userId: Int64
    let nickname: String
    let profileImage: String
    let attachment: String?
    @Published var likeCount: Int

    init(id: Int64?, message: String, userId: Int64, nickname: String, profileImage: String, attachment: String?, likeCount: Int) {
        self.id = id
        self.message = message
        self.userId = userId
        self.nickname = nickname
        self.profileImage = profileImage
        self.attachment = attachment
        self.likeCount = likeCount
    }
 }
