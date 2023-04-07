//
//  AppState.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/07.
//

import Foundation

class AppState {
    static let shared = AppState()

    // 커스텀 백 버튼을 추가하면 SwipeBack이 작동하지 않으므로,
    // 이를 해결하기 위한 코드를 작성했습니다.
    var swipeEnabled = false
}
