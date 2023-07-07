//
//  UserRemoteService.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/07/07.
//

import Foundation
import Alamofire
import Combine

class UserRemoteService: UserRemoteServiceProtocol {
    private let baseURL = "https://api.klock.app/api/users"

    func existed(nickName: String) -> AnyPublisher<ExistedNickNameResDTO, Alamofire.AFError> {
        let url = "\(baseURL)/existedNickName"
        let requestDTO = ExistedNickNameReqDTO(nickName: nickName)

        return AF.request(url, method: .post, parameters: requestDTO.dictionary, encoding: JSONEncoding.default)
            .validate()
            .publishDecodable(type: ExistedNickNameResDTO.self)
            .tryMap { result -> ExistedNickNameResDTO in
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
}
