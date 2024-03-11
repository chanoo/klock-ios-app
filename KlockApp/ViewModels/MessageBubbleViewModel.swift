//
//  MessageBubbleViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 3/11/24.
//

import Foundation
import Combine

class MessageBubbleViewModel: ObservableObject {
    @Published var userTraceModel: UserTraceModel?

    let deleteUserTraceTapped = PassthroughSubject<Int64, Never>() // 삭제할 사용자 추적 데이터의 ID를 전달하는 Subject

    private let userTraceService = Container.shared.resolve(UserTraceRemoteServiceProtocol.self)
}
