//
//  ChatGPTServiceProtocol.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/12.
//

import Foundation

protocol ChatGPTServiceProtocol {
    func send(messages: [MessageModel], onReceived: @escaping (String) -> Void, completion: @escaping (Result<String, Error>) -> Void)
}
