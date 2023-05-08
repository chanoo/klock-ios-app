//
//  TimerRemoteService.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/05/02.
//

import Foundation
import Alamofire
import Combine

class TimerRemoteService: TimerRemoteServiceProtocol, APIServiceProtocol {
    private let baseURL = "https://api.klock.app/api/timers"

    func fetch() -> AnyPublisher<[TimerDTO], AFError> {
        let url = "\(baseURL)"

        return Future<[TimerDTO], AFError> { promise in
            AF.request(url, method: .get, headers: self.headers())
                .validate()
                .response { response in
                    switch response.result {
                    case .success(let data):
                        do {
                            let timerItems = try decodeTimerItems(from: data!)
                            promise(.success(timerItems))
                        } catch {
                            promise(.failure(AFError.responseSerializationFailed(reason: .decodingFailed(error: error))))
                        }
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }

}
