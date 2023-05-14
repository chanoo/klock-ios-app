//
//  TimerModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/05/11.
//

import Foundation
import Combine
import SwiftUI

class TimerModel: ObservableObject, Identifiable {
    let id: Int64?
    let userId: Int64?
    let seq: Int
    let type: String?
    @Published var name: String

    init(id: Int64?, userId: Int64?, seq: Int, type: String?, name: String) {
        self.id = id
        self.userId = userId
        self.seq = seq
        self.type = type
        self.name = name
    }
}
