//
//  AccountTimerServiceProtocol.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/23.
//

import Foundation
import Combine

protocol AccountTimerServiceProtocol {
    func fetch() -> AnyPublisher<[AccountTimer], Error>
    func create(account: Account, type: AccountTimerType, active: Bool, createdAt: Date) -> AnyPublisher<AccountTimer, Error>
    func delete(id: Int64) -> AnyPublisher<Bool, Error>
    func update(id: Int64, active: Bool) -> AnyPublisher<AccountTimer, Error>
}
