//
//  PomodoroTimerViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/23.
//

import Foundation

class PomodoroTimerViewModel: ObservableObject {
    @Published var isFlipped: Bool = false
    @Published var workTime: Int = 25
    @Published var breakTime: Int = 5
    @Published var repeatCount: Int = 4
    @Published var isPomodoroModalShown: Bool = false
    @Published var pomodoroCardPosition: CGPoint = CGPoint(x: 0, y: 0)
    @Published var pomodoroCardSize: CGSize = CGSize(width: 0, height: 0)
    
    init() {
        debugPrint("PomodoroTimerViewModel init")
    }
}
