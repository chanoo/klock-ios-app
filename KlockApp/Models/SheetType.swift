//
//  SheetType.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/06/16.
//

enum SheetType: Identifiable {
    case qrcode
    case nickname
    case nearby
    case none
    
    var id: Int {
        switch self {
        case .qrcode:
            return 1
        case .nickname:
            return 2
        case .nearby:
            return 3
        case .none:
            return 4
        }
    }
}
