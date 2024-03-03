//
//  FollowCode.swift
//  KlockApp
//
//  Created by 성찬우 on 12/31/23.
//

import Foundation

struct FollowCode: Hashable, Codable {
    let issueDate: String
    let expireDate: String
    let followId: Int64
    
    func toJson() -> String? {
         let encoder = JSONEncoder()
         encoder.outputFormatting = .prettyPrinted // if you want pretty print, otherwise remove this line
         do {
             let jsonData = try encoder.encode(self)
             if let jsonString = String(data: jsonData, encoding: .utf8) {
                 return jsonString
             }
         } catch {
             print("Error converting UserModel to JSON: \(error)")
         }
         return nil
     }
}

// 날짜 포맷터 설정
func formattedDate(from date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // 원하는 날짜 형식으로 설정
    return dateFormatter.string(from: date)
}

// FollowCode 인스턴스 생성 함수
func createFollowCode(for userId: Int64) -> FollowCode {
    let now = Date()
    let threeMinutesLater = Calendar.current.date(byAdding: .minute, value: 3, to: now)!

    return FollowCode(
        issueDate: formattedDate(from: now),
        expireDate: formattedDate(from: threeMinutesLater),
        followId: userId
    )
}
