//
//  StudySessionRemoteService.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/05/19.
//

import Foundation
import Alamofire
import Combine

class StudySessionRemoteService: StudySessionRemoteServiceProtocol, APIServiceProtocol {
    private let baseURL = "https://api.klock.app/api/v1/study-sessions"

    private let logger = AlamofireLogger()
    private let session: Session

    init() {
        session = Session(eventMonitors: [logger])
    }
    
    func create(data: ReqStudySession) -> AnyPublisher<ResStudySession, AFError> {
        let url = "\(baseURL)"
        
        return session.request(url, method: .post, parameters: data, encoder: JSONParameterEncoder.default, headers: self.headers())
            .validate(statusCode: 200..<300)
            .publishDecodable(type: ResStudySession.self)
            .value()
            .eraseToAnyPublisher()
    }

    func update(id: Int64, data: ReqStudySession) -> AnyPublisher<ResStudySession, AFError> {
        let url = "\(baseURL)/\(id)"

        return AF.request(url, method: .put, parameters: data, encoder: JSONParameterEncoder.default, headers: self.headers())
            .validate(statusCode: 200..<300)
            .publishDecodable(type: ResStudySession.self)
            .value()
            .eraseToAnyPublisher()
    }

}
