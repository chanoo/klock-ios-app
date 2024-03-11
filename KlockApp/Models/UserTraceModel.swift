//
//  UserTraceModel.swift
//  KlockApp
//
//  Created by 성찬우 on 3/11/24.
//

import Foundation
import Combine

class UserTraceModel: ObservableObject, Identifiable {
    let id: Int64
    let writeUserId: Int64
    let writeNickname: String
    let writeUserImage: String?
    let type: UserTraceType
    let contents: String
    let contentsImage: String?
    @Published var heartCount: Int
    var createdAt: String

    init(id: Int64, writeUserId: Int64, writeNickname: String, writeUserImage: String?, type: UserTraceType, contents: String, contentsImage: String?, heartCount: Int, createdAt: String) {
        self.id = id
        self.writeUserId = writeUserId
        self.writeNickname = writeNickname
        self.writeUserImage = writeUserImage
        self.type = type
        self.contents = contents
        self.contentsImage = contentsImage
        self.heartCount = heartCount
        self.createdAt = createdAt
    }

    static func from(dto: UserTraceResDTO) -> UserTraceModel {
        return UserTraceModel(id: dto.id, writeUserId: dto.writeUserId, writeNickname: dto.writeNickname, writeUserImage: dto.writeUserImage, type: dto.type, contents: dto.contents, contentsImage: dto.contentsImage, heartCount: dto.heartCount, createdAt: dto.createdAt)
    }
}
