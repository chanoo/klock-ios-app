//
//  StudySessionServiceProtocol.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/15.
//

import Foundation
import Combine

protocol StudySessionServiceProtocol {
    func fetchStudySessions() -> AnyPublisher<[StudySessionModel], Error>
    func saveStudySession(accountTimer: AccountTimer, startTime: Date, endTime: Date) -> AnyPublisher<StudySessionModel, Error>
    func deleteStudySessionById(id: Int64) -> AnyPublisher<Bool, Error>
    func deleteStoredStudySessions() -> AnyPublisher<Bool, Error>
}
