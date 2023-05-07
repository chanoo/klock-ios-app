//
//  TimerRemoteService.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/05/02.
//

import Foundation
import Alamofire
import Combine

class TimerRemoteService: TimerRemoteServiceProtocol {
    
    private let baseURL = "https://api.klock.app/api/timers"

    func fetch() -> AnyPublisher<[TimerDTO], Error> {
        let url = "\(baseURL)"
        
        // JWT 값을 꺼냅니다.
        let jwtToken = UserDefaults.standard.string(forKey: "access.token") ?? ""

        // Alamofire의 request에 Authorization 헤더를 추가합니다.
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(jwtToken)"
        ]

        return Future { promise in
            AF.request(url, method: .get, headers: headers)
                .validate()
                .response { response in
                    switch response.result {
                    case .success(let data):
                        do {
                            let timerItems = try decodeTimerItems(from: data!)
                            promise(.success(timerItems))
                        } catch {
                            promise(.failure(error))
                        }
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
