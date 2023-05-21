//
//  DateUtils.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/05/21.
//

import Foundation

struct DateUtils {
    static func doubleToDate(_ timeDouble: Double) -> Date {
        return Date(timeIntervalSince1970: timeDouble)
    }
    
    static func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter.string(from: date)
    }
}
