//
//  UserTraceGroup.swift
//  KlockApp
//
//  Created by 성찬우 on 2/15/24.
//

import Foundation

struct UserTraceGroup: Identifiable {
    var id: String { date }
    let date: String
    var userTraces: [UserTraceFetchResDTO]
}
