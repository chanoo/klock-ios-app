//
//  PomodoroTimerRemoteService.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/05/07.
//

import Foundation
import Alamofire
import Combine

class PomodoroTimerRemoteService: PomodoroTimerRemoteServiceProtocol, APIServiceProtocol {
    private let baseURL = "https://api.klock.app/api/v1/pomodoro-timers"
    
    private let logger = AlamofireLogger()
    private let session: Session

    init() {
        session = Session(eventMonitors: [logger])
    }
    
    func create(data: ReqPomodoroTimer) -> AnyPublisher<PomodoroTimerDTO, AFError> {
        let url = "\(baseURL)"

        return session.request(url, method: .post, parameters: data, encoder: JSONParameterEncoder.default, headers: self.headers())
            .validate()
            .publishDecodable(type: PomodoroTimerDTO.self)
            .value()
            .eraseToAnyPublisher()
    }

    func update(id: Int64, data: ReqPomodoroTimer) -> AnyPublisher<PomodoroTimerDTO, AFError> {
        let url = "\(baseURL)/\(id)"

        return session.request(url, method: .put, parameters: data, encoder: JSONParameterEncoder.default, headers: self.headers())
            .validate()
            .publishDecodable(type: PomodoroTimerDTO.self)
            .value()
            .eraseToAnyPublisher()
    }

    func delete(id: Int64) -> AnyPublisher<Void, AFError> {
        let url = "\(baseURL)/\(id)"

        return session.request(url, method: .delete, headers: self.headers())
            .validate()
            .publishData()
            .tryMap { dataResponse -> Void in
                if let statusCode = dataResponse.response?.statusCode, statusCode >= 200, statusCode < 300 {
                    return ()
                } else {
                    throw dataResponse.error ?? AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: dataResponse.response?.statusCode ?? -1))
                }
            }
            .mapError { error -> AFError in
                if let afError = error as? AFError {
                    return afError
                } else {
                    return AFError.sessionTaskFailed(error: error)
                }
            }
            .eraseToAnyPublisher()
    }

}
