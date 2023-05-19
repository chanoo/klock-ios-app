//
//  StudySessionRemoteServiceProtocol.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/05/19.
//

import Foundation
import Combine
import Alamofire

protocol StudySessionRemoteServiceProtocol {
    func create(data: ReqStudySession) -> AnyPublisher<ResStudySession, AFError>
    func update(id: Int64, data: ReqStudySession) -> AnyPublisher<ResStudySession, AFError>
}
