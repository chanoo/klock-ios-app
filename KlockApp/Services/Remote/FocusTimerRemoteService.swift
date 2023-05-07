import Foundation
import Alamofire
import Combine

class FocusTimerRemoteService: FocusTimerRemoteServiceProtocol {
    private let baseURL = "https://api.klock.app/api/focus-timers"
    
    private func headers() -> HTTPHeaders {
        let jwtToken = UserDefaults.standard.string(forKey: "access.token") ?? ""
        return [
            "Authorization": "Bearer \(jwtToken)"
        ]
    }
    
    private func handleResponse<T>(_ response: DataResponse<Data?, AFError>, decodingType: T.Type) -> Result<T, Error> where T: Decodable {
        switch response.result {
        case .success(let data):
            if let unwrappedData = data {
                do {
                    let item = try decodeTimerItem(from: unwrappedData) as! T
                    return .success(item)
                } catch {
                    return .failure(error)
                }
            } else {
                return .failure(DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Received empty data")))
            }
        case .failure(let error):
            return .failure(error)
        }
    }

    func create(data: FocusTimerDTO) -> AnyPublisher<FocusTimerDTO, Error> {
        let url = "\(baseURL)"

        return Future { promise in
            AF.request(url, method: .post, parameters: data, encoder: JSONParameterEncoder.default, headers: self.headers())
                .validate()
                .response { (response: DataResponse<Data?, AFError>) in
                    promise(self.handleResponse(response, decodingType: FocusTimerDTO.self))
                }
        }
        .eraseToAnyPublisher()
    }

    func update(id: Int64, data: FocusTimerDTO) -> AnyPublisher<FocusTimerDTO, Error> {
        let url = "\(baseURL)/\(id)"

        return Future { promise in
            AF.request(url, method: .post, parameters: data, encoder: JSONParameterEncoder.default, headers: self.headers())
                .validate()
                .response { (response: DataResponse<Data?, AFError>) in
                    promise(self.handleResponse(response, decodingType: FocusTimerDTO.self))
                }
        }
        .eraseToAnyPublisher()
    }

    func delete(id: Int64) -> AnyPublisher<Void, Error> {
        let url = "\(baseURL)/\(id)"

        return Future { promise in
            AF.request(url, method: .delete, headers: self.headers())
                .validate(statusCode: 200..<300)
                .response { (response: DataResponse<Data?, AFError>) in
                    switch response.result {
                    case .success:
                        promise(.success(()))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
