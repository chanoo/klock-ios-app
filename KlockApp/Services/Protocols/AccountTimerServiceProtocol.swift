//
//  AccountTimerServiceProtocol.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/23.
//

import Foundation
import Combine

protocol AccountTimerServiceProtocol {
    func fetch() -> AnyPublisher<[AccountTimerModel], Error>
    func create(accountID: Int64, type: String, active: Bool) -> AnyPublisher<AccountTimerModel, Error>
    func delete(id: Int64) -> AnyPublisher<Bool, Error>
    func update(id: Int64, active: Bool) -> AnyPublisher<AccountTimerModel, Error>
}
