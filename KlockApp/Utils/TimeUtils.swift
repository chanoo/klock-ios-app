//
//  TimeUtils.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/20.
//

import Foundation

struct TimeUtils {

    static func elapsedTimeToString(elapsedTime: TimeInterval) -> String {
        let hours = Int(elapsedTime) / 3600
        let minutes = Int(elapsedTime) % 3600 / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    static func angleForTime(date: Date) -> Double {
        let hour = Calendar.current.component(.hour, from: date)
        let minute = Calendar.current.component(.minute, from: date)
        let second = Calendar.current.component(.second, from: date)
        let totalSeconds = Double(hour * 3600 + minute * 60 + second)
        return totalSeconds / 43200 * 360
    }
}
