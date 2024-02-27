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
    private let baseURL = "https://api.klock.app/api/v1/users"
    private let logger = AlamofireLogger()
    private let session: Session
    
    init() {
        session = Session(eventMonitors: [logger])
    }
    
    func get(id: Int64) -> AnyPublisher<GetUserResDTO, Alamofire.AFError> {
        let url = "\(baseURL)/\(id)"
        
        return session.request(url, method: .get, encoding: JSONEncoding.default, headers: self.headers())
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
            .mapError { error -> AFError in
                if let afError = error as? AFError {
                    return afError
                } else {
                    return AFError.sessionTaskFailed(error: error)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func existed(nickname: String) -> AnyPublisher<ExistedNicknameResDTO, Alamofire.AFError> {
        let url = "\(baseURL)/existed-nickname"
        let requestDTO = ExistedNicknameReqDTO(nickname: nickname)
        
        return session.request(url, method: .post, parameters: requestDTO.dictionary, encoding: JSONEncoding.default)
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
            .mapError { error -> AFError in
                if let afError = error as? AFError {
                    return afError
                } else {
                    return AFError.sessionTaskFailed(error: error)
                }
            }
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
    
    func update(id: Int64, request: UserUpdateReqDTO) -> AnyPublisher<UserUpdateResDTO, AFError> {
        let url = "\(baseURL)/\(id)"
        
        return session.request(url, method: .put, parameters: request.dictionary, encoding: JSONEncoding.default, headers: self.headers())
            .validate()
            .publishDecodable(type: UserUpdateResDTO.self)
            .tryMap { result -> UserUpdateResDTO in
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
            .mapError { error -> AFError in
                if let afError = error as? AFError {
                    return afError
                } else {
                    return AFError.sessionTaskFailed(error: error)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func profileImage(id: Int64, request: ProfileImageReqDTO) -> AnyPublisher<ProfileImageResDTO, Alamofire.AFError> {
        let url = "\(baseURL)/\(id)/profile-image"
        
        return Future<ProfileImageResDTO, AFError> { promise in
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(request.file, withName: "file", fileName: "profile-image-\(id).png", mimeType: "image/png")
            }, to: url, method: .post, headers: self.headers())
            .validate()
            .responseDecodable(of: ProfileImageResDTO.self) { response in
                switch response.result {
                case .success(let resDTO):
                    promise(.success(resDTO))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    
    func searchBy(nickname: String) -> AnyPublisher<SearchByNicknameResDTO?, APIError> {
        let url = "\(baseURL)/search-by-nickname"
        let requestDTO = SearchByNicknameReqDTO(nickname: nickname)
        
        return Future<SearchByNicknameResDTO?, APIError> { promise in
            self.session.request(url, method: .post, parameters: requestDTO.dictionary, encoding: JSONEncoding.default, headers: self.headers())
                .validate()
                .responseDecodable(of: SearchByNicknameResDTO?.self) { response in
                    switch response.result {
                    case .success(let value):
                        // 성공적으로 응답을 받았으나, 응답이 nil일 수 있음
                        promise(.success(value))
                    case .failure(_):
                        // Alamofire의 에러를 APIError로 변환
                        let apiError = APIError.custom(response.response?.statusCode ?? 0, "알수 없는 에러 입니다.")
                        if let data = response.data {
                            let decoder = JSONDecoder()
                            if let errorResponse = try? decoder.decode(APIErrorModel.self, from: data) {
                                // 서버에서 반환한 에러 메시지를 사용
                                promise(.failure(.custom(response.response?.statusCode ?? 0, errorResponse.error)))
                            } else {
                                promise(.failure(apiError))
                            }
                        } else {
                            promise(.failure(apiError))
                        }
                    }
                }
        }.eraseToAnyPublisher()
    }
}
