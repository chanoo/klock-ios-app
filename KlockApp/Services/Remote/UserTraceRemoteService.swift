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
    private let baseURL = "https://api.klock.app/api/v1/user-trace"
    
    private let logger = AlamofireLogger()
    private let session: Session

    init() {
        session = Session(eventMonitors: [logger])
    }
    
    func fetch() -> AnyPublisher<[UserTraceFetchResDTO], Alamofire.AFError> {
        let url = "\(baseURL)"

        return AF.request(url, method: .get, encoding: JSONEncoding.default)
            .validate()
            .publishDecodable(type: [UserTraceFetchResDTO].self)
            .value()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    func create(data: UserTraceCreateReqDTO) -> AnyPublisher<UserTraceCreateResDTO, Alamofire.AFError> {
        let url = "\(baseURL)"
        
        return Future<UserTraceCreateResDTO, Alamofire.AFError> { promise in
            self.session.upload(multipartFormData: { multipartFormData in
                // Append the image data
                if let image = data.image {
                    multipartFormData.append(image, withName: "image", fileName: "image.png", mimeType: "image/png")
                }
                
                // Append the JSON data
                let contentTrace = ["writeUserId": data.contentTrace.writeUserId, "contents": data.contentTrace.contents]
                if let jsonData = try? JSONSerialization.data(withJSONObject: contentTrace, options: []) {
                    multipartFormData.append(jsonData, withName: "contentTrace", mimeType: "application/json")
                }
            }, to: url, method: .post, headers: self.headers())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: UserTraceCreateResDTO.self) { response in
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
