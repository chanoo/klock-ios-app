//
//  AccountRemoteServiceProtocol.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/24.
//

import Foundation
import Combine

protocol AccountRemoteServiceProtocol {
    func get(id: Int64) -> AnyPublisher<UserModel, Error>
    func create(email: String, username: String) -> AnyPublisher<UserModel, Error>
    func fetch() -> AnyPublisher<[UserModel], Error>
    func update(id: Int64, email: String?, username: String?, totalStudyTime: Int?, active: Bool?) -> AnyPublisher<UserModel, Error>
    func delete(id: Int64) -> AnyPublisher<Bool, Error>
}
