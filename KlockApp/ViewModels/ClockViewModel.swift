//
//  ClockViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/05/21.
//

import Foundation

class ClockViewModel: ObservableObject {
    @Published var currentTime: Date
    @Published var startTime: Date
    @Published var elapsedTime: TimeInterval
    @Published var isStudying: Bool
    @Published var isRunning: Bool

    init(currentTime: Date = Date(),
         startTime: Date = Date(),
         elapsedTime: TimeInterval = 0,
         isStudying: Bool = false,
         isRunning: Bool = false) {

        self.currentTime = currentTime
        self.startTime = startTime
        self.elapsedTime = elapsedTime
        self.isStudying = isStudying
        self.isRunning = isRunning
    }
    
    func startStudy() {
        isStudying = true
    }

    func stopStudy() {
        isStudying = false
    }
    
    func elapsedTimeToString() -> String {
        return TimeUtils.elapsedTimeToString(elapsedTime: elapsedTime)
    }
    
    var isAfternoon: Bool {
        return Calendar.current.component(.hour, from: currentTime) >= 12
    }
}
