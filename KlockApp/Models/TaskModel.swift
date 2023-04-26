//
//  TaskModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/26.
//

import Foundation

struct TaskModel: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let participants: [String]
    let progress: Double
    let startDate: Date
    let endDate: Date
    var pokeCounts: [String: Int]
}
