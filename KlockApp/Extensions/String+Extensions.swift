//
//  String+Extensions.swift
//  KlockApp
//
//  Created by 성찬우 on 12/31/23.
//

import Foundation

extension String {
    // Base64 인코딩
    func base64Encoded() -> String? {
        guard let data = self.data(using: .utf8) else { return nil }
        return data.base64EncodedString()
    }

    // Base64 디코딩
    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    // String 형태의 날짜를 "오후 1:09"와 같은 형식으로 변환하는 메서드
    func toTimeFormat() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // ISO 8601 형식 지정
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") // UTC로 설정
        guard let date = dateFormatter.date(from: self) else { return nil }
        
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone.current // 사용자의 현재 시간대로 설정
        dateFormatter.dateFormat = "a h:mm" // "오후 1:09" 형식
        
        return dateFormatter.string(from: date)
    }
    
    func toDateFormat() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // ISO 8601 형식 지정
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") // UTC로 설정
        guard let date = dateFormatter.date(from: self) else { return nil }
        
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "오늘"
        } else if calendar.isDateInYesterday(date) {
            return "어제"
        } else {
            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.timeZone = TimeZone.current // 사용자의 현재 시간대로 설정
            dateFormatter.dateFormat = "yyyy년 MM월 dd일" // 날짜 형식
            return dateFormatter.string(from: date)
        }
    }
}
