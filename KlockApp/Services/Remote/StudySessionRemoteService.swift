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

    func update(id: Int64, data: StudySessionUpdateReqDTO) -> AnyPublisher<StudySessionUpdateResDTO, AFError> {
        let url = "\(baseURL)/\(id)"

        return session.request(url, method: .put, parameters: data, encoder: JSONParameterEncoder.default, headers: self.headers())
            .validate(statusCode: 200..<300)
            .publishDecodable(type: StudySessionUpdateResDTO.self)
            .value()
            .eraseToAnyPublisher()
    }

    func fetch(userId: Int64, startDate: String, endDate: String) -> AnyPublisher<[GetStudySessionsResDTO], Alamofire.AFError> {
        let url = "\(baseURL)/period?userId=\(userId)&startDate=\(startDate)&endDate=\(endDate)"

        return session.request(url, method: .get, encoding: JSONEncoding.default, headers: self.headers())
            .validate()
            .publishDecodable(type: [GetStudySessionsResDTO].self)
            .value()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}
