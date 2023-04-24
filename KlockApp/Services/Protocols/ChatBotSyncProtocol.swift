//
//  ChatBotSyncProtocol.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/25.
//

import Foundation
import Combine

protocol ChatBotSyncProtocol {
    func sync() -> AnyPublisher<Void, Error>
}
