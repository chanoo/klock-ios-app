//
//  UserRemoteService.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/07/07.
//

import Foundation
import Alamofire
import Combine

class UserRemoteService: UserRemoteServiceProtocol, APIServiceProtocol {
    private let baseURL = "https://api.klock.app/api/users"
    private let logger = AlamofireLogger()
    private let session: Session

    init() {
        session = Session(eventMonitors: [logger])
    }
    
    func get(id: Int64) -> AnyPublisher<GetUserResDTO, Alamofire.AFError> {
        let url = "\(baseURL)/\(id)"
        
        return AF.request(url, method: .get, encoding: JSONEncoding.default, headers: self.headers())
            .validate()
            .publishDecodable(type: GetUserResDTO.self)
            .tryMap { result -> GetUserResDTO in
                switch result.result {
                case .success(let response):
                    return response
                case .failure(let error):
                    if let data = result.data {
                        let decoder = JSONDecoder()
                        if let errorResponse = try? decoder.decode(APIErrorModel.self, from: data) {
                            print("Server error message: \(errorResponse.error)")
                        }
                    }
                    throw error
                }
            }
            .mapError { $0 as! AFError }
            .eraseToAnyPublisher()
    }
    
    func existed(nickname: String) -> AnyPublisher<ExistedNicknameResDTO, Alamofire.AFError> {
        let url = "\(baseURL)/existed-nickname"
        let requestDTO = ExistedNicknameReqDTO(nickname: nickname)
        
        return AF.request(url, method: .post, parameters: requestDTO.dictionary, encoding: JSONEncoding.default)
            .validate()
            .publishDecodable(type: ExistedNicknameResDTO.self)
            .tryMap { result -> ExistedNicknameResDTO in
                switch result.result {
                case .success(let response):
                    return response
                case .failure(let error):
                    if let data = result.data {
                        let decoder = JSONDecoder()
                        if let errorResponse = try? decoder.decode(APIErrorModel.self, from: data) {
                            print("Server error message: \(errorResponse.error)")
                        }
                    }
                    throw error
                }
            }
            .mapError { $0 as! AFError }
            .eraseToAnyPublisher()
    }

    func delete(id: Int64) -> AnyPublisher<Void, AFError> {
        let url = "\(baseURL)/\(id)"

        return AF.request(url, method: .delete, headers: self.headers())
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
