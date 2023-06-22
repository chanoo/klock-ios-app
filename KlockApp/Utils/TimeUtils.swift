//
//  TimeUtils.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/20.
//

import Foundation

struct TimeUtils {
    /// 이 함수는 초 단위의 시간을 시, 분, 초로 변환하여 문자열로 반환합니다.
    ///
    /// - Parameter elapsedTime: 변환할 초 단위의 시간입니다.
    /// - Returns: "HH:mm:ss" 형식의 문자열을 반환합니다.
    static func elapsedTimeToString(elapsedTime: TimeInterval) -> String {
        let hours = Int(elapsedTime) / 3600
        let minutes = Int(elapsedTime) % 3600 / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    /// 이 함수는 주어진 날짜의 시간을 이용하여 각도를 계산하여 반환합니다.
    ///
    /// - Parameter date: 각도를 계산할 날짜입니다.
    /// - Returns: 시간을 기반으로 계산한 각도를 반환합니다.
    static func angleForTime(date: Date) -> Double {
        let hour = Calendar.current.component(.hour, from: date)
        let minute = Calendar.current.component(.minute, from: date)
        let second = Calendar.current.component(.second, from: date)
        let totalSeconds = Double(hour * 3600 + minute * 60 + second)
        return totalSeconds / 43200 * 360
    }
    
    /// 이 함수는 초 단위의 시간을 시, 분, 초로 변환하고, 문자열로 반환합니다.
    /// 만약 시나 분이 0인 경우 해당 단위는 표시하지 않습니다.
    ///
    /// - Parameter seconds: 변환할 초 단위의 시간입니다.
    /// - Returns: 시, 분, 초를 포함하는 문자열을 반환합니다.
    ///            시간이 0이면 "mm:ss" 형식, 시간과 분이 0이면 "ss" 형식의 문자열을 반환합니다.
    static func secondsToHMS(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = seconds % 60

        if hours > 0 {
            return String(format: "%02d시간 %02d분 %02d초", hours, minutes, seconds)
        } else if minutes > 0 {
            return String(format: "%02d분 %02d초", minutes, seconds)
        } else {
            return String(format: "%02d초", seconds)
        }
    }
    
    /// 이 함수는 주어진 날짜와 포맷을 받아 해당 포맷에 따른 날짜/시간 문자열을 반환합니다.
    ///
    /// - Parameters:
    ///   - date: 변환할 날짜입니다.
    ///   - format: 출력할 날짜/시간 문자열의 포맷입니다.
    /// - Returns: 주어진 포맷에 따른 날짜/시간 문자열을 반환합니다.
    static func formattedDateString(from date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    /// 이 함수는 주어진 문자열과 포맷을 받아 해당 포맷에 따른 날짜 객체를 반환합니다.
    ///
    /// - Parameters:
    ///   - dateString: 변환할 날짜/시간 문자열입니다.
    ///   - format: 입력 문자열의 날짜/시간 포맷입니다.
    /// - Returns: 주어진 포맷에 따른 날짜 객체를 반환합니다. 변환에 실패한 경우 nil을 반환합니다.
    static func dateFromString(dateString: String, format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: dateString)
    }
}
