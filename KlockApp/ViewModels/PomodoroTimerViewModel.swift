//
//  PomodoroTimerViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/05/18.
//

import Foundation
import Combine

class PomodoroTimerViewModel: ObservableObject {
    
    @Published var elapsedTime: TimeInterval = 0

    var model: PomodoroTimerModel
    
    init(model: PomodoroTimerModel) {
        self.model = model
    }
    
    func elapsedTimeToString() -> String {
        return TimeUtils.elapsedTimeToString(elapsedTime: elapsedTime)
    }
    
}
