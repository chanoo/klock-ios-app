//
//  UserTraceRemoteService.swift
//  KlockApp
//
//  Created by 성찬우 on 2/13/24.
//

import Alamofire
import Combine
import Foundation

class UserTraceRemoteService: UserTraceRemoteServiceProtocol, APIServiceProtocol {
    private let baseURL = "https://api.klock.app"
//    private let baseURL = "http://192.168.68.73:8080"
    
    private let logger = AlamofireLogger()
    private let session: Session

    init() {
        session = Session(eventMonitors: [])
    }
    
    func fetch(userId: Int64, page: Int, size: Int? = 10) -> AnyPublisher<[UserTraceResDTO], Alamofire.AFError> {
        let url = "\(baseURL)/api/v1/user-trace?userId=\(userId)&page=\(page)&size=\(size ?? 10)"
        
        return session.request(url, method: .get, encoding: JSONEncoding.default, headers: self.headers())
            .validate()
            .publishDecodable(type: [UserTraceResDTO].self)
            .value()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    func create(data: UserTraceCreateReqDTO) -> AnyPublisher<UserTraceResDTO, Alamofire.AFError> {
        let url = "\(baseURL)/api/v1/user-trace"
        
        return Future<UserTraceResDTO, Alamofire.AFError> { promise in
            self.session.upload(multipartFormData: { multipartFormData in
                // Append the image data
                if let image = data.image {
                    multipartFormData.append(image, withName: "image", fileName: "image.png", mimeType: "image/png")
                }
                
                // Append the JSON data
                let contentTrace = ["userId": data.contentTrace.userId, "writeUserId": data.contentTrace.writeUserId, "type": data.contentTrace.type.rawValue, "contents": data.contentTrace.contents ?? ""]
                if let jsonData = try? JSONSerialization.data(withJSONObject: contentTrace, options: []) {
                    multipartFormData.append(jsonData, withName: "contentTrace", mimeType: "application/json")
                }
            }, to: url, method: .post, headers: self.headers())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: UserTraceResDTO.self) { response in
                switch response.result {
                case .success(let value):
                    promise(.success(value))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func delete(id: Int64) -> AnyPublisher<Void, Alamofire.AFError> {
        let url = "\(baseURL)/api/v1/user-trace/\(id)"

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
