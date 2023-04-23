//
//  AccountServiceProtocol.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/24.
//

import Foundation
import Combine

protocol AccountServiceProtocol {
    func get(id: Int64) -> AnyPublisher<Account, Error>
    func create(email: String, username: String) -> AnyPublisher<Account, Error>
    func fetch() -> AnyPublisher<[Account], Error>
    func update(id: Int64, email: String?, username: String?, totalStudyTime: Int?, active: Bool?) -> AnyPublisher<Account, Error>
    func delete(id: Int64) -> AnyPublisher<Bool, Error>
}
