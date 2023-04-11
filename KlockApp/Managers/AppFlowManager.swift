//
//  AppFlowManager.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/11.
//

import Combine

class AppFlowManager: ObservableObject {
    @Published var destination: Destination? = nil
    let navigateToDestination = PassthroughSubject<Destination?, Never>()
}
