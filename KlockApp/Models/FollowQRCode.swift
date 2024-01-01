//
//  FollowQRCode.swift
//  KlockApp
//
//  Created by 성찬우 on 1/1/24.
//

import Foundation

struct FollowQRCode: Hashable, Codable {
    let followData: String
    let encryptedKey: String
    
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
