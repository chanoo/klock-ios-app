//
//  AppFlowManager.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/11.
//

import Combine

class AppFlowManager: ObservableObject {
    let navigateToDestination = PassthroughSubject<Destination?, Never>()
}
