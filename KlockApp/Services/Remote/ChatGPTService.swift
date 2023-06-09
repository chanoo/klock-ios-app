// ChatGPTService.swift
// KlockApp
//
// Created by 성찬우 on 2023/04/12.
//

import Foundation
import Alamofire
import Combine

class ChatGPTService: ChatGPTServiceProtocol, APIServiceProtocol {

    private let apiKey = EnvironmentValuesProvider.shared.openaiAPIKey
    private let session: Session
    private let logger = AlamofireLogger()

    init() {
        session = Session(eventMonitors: [logger])
    }
    
    func send(messages: [MessageModel], onReceived: @escaping (String) -> Void, completion: @escaping (Result<String, Error>) -> Void) {
        let urlString = "https://api.openai.com/v1/chat/completions"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        let headers: HTTPHeaders = [
            "Accept": "text/event-stream",
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]

        let parameters = ChatCompletionsReqDTO(messages: messages)
        let request = session.streamRequest(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
        request.responseStreamString { stream in
            switch stream.event {
            case let .stream(result):
                switch result {
                case let .success(eventString):
                    let lines = eventString.components(separatedBy: .newlines)
                    for line in lines where line.starts(with: "data:") {
                        let eventData = line.dropFirst(5).trimmingCharacters(in: .whitespacesAndNewlines)
                        if eventData == "[DONE]" { // 추가
                            DispatchQueue.main.async {
                                completion(.success(""))
                            }
                        } else if let data = eventData.data(using: .utf8), let response = try? JSONDecoder().decode(ChatCompletionsResDTO.self, from: data), let deltaContent = response.choices.first?.delta.content {
                            DispatchQueue.main.async {
                                onReceived(deltaContent)
                            }
                        }
                    }

                case let .failure(error):
                    print("Error: \(error.localizedDescription)")
                    completion(.failure(error))
                }

            case let .complete(completion):
                if let error = completion.error {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }

    }
}
