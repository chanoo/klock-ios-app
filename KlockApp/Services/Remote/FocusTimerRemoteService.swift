import Foundation
import Alamofire
import Combine

class FocusTimerRemoteService: FocusTimerRemoteServiceProtocol, APIServiceProtocol {
    private let baseURL = "https://api.klock.app/api/focus-timers"

    private let logger = AlamofireLogger()
    private let session: Session

    init() {
        session = Session(eventMonitors: [logger])
    }
    
    func create(data: ReqFocusTimer) -> AnyPublisher<FocusTimerDTO, AFError> {
        let url = "\(baseURL)"

        return session.request(url, method: .post, parameters: data, encoder: JSONParameterEncoder.default, headers: self.headers())
            .validate()
            .publishDecodable(type: FocusTimerDTO.self)
            .value()
            .eraseToAnyPublisher()
    }

    func update(id: Int64, data: ReqFocusTimer) -> AnyPublisher<FocusTimerDTO, AFError> {
        let url = "\(baseURL)/\(id)"

        return AF.request(url, method: .put, parameters: data, encoder: JSONParameterEncoder.default, headers: self.headers())
            .validate()
            .publishDecodable(type: FocusTimerDTO.self)
            .value()
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
