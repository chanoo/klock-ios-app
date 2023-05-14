//
//  ExamTimerRemoteServiceProtocol.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/05/07.
//

import Foundation
import Combine
import Alamofire

protocol ExamTimerRemoteServiceProtocol {
    func create(data: ReqExamTimer) -> AnyPublisher<ExamTimerDTO, AFError>
    func update(id: Int64, data: ReqExamTimer) -> AnyPublisher<ExamTimerDTO, AFError>
    func delete(id: Int64) -> AnyPublisher<Void, AFError>
}
