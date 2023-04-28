//
//  AccountLocalServiceProtocol.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/28.
//

import Foundation
import Combine

protocol AccountLocalServiceProtocol {
    func get(id: Int64) -> AnyPublisher<AccountModel, Error>
    func create(email: String, username: String) -> AnyPublisher<AccountModel, Error>
    func fetch() -> AnyPublisher<[AccountModel], Error>
    func update(id: Int64, email: String?, username: String?, totalStudyTime: Int?, active: Bool?) -> AnyPublisher<AccountModel, Error>
    func delete(id: Int64) -> AnyPublisher<Bool, Error>
}
