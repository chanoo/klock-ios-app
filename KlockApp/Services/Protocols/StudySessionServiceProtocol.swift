//
//  StudySessionServiceProtocol.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/15.
//

import Foundation
import Combine

protocol StudySessionServiceProtocol {
    func fetch() -> AnyPublisher<[StudySessionModel], Error>
    func save(accountID: Int64, accountTimerID: Int64, startTime: Date, endTime: Date) -> AnyPublisher<StudySessionModel, Error>
    func delete(id: Int64) -> AnyPublisher<Bool, Error>
    func deleteAll() -> AnyPublisher<Bool, Error>
}
