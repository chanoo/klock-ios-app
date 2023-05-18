//
//  ExamTimerViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/05/18.
//

import Foundation
import Combine

class ExamTimerViewModel: ObservableObject {
    
    @Published var elapsedTime: TimeInterval = 0

    var model: ExamTimerModel
    
    init(model: ExamTimerModel) {
        self.model = model
    }

}
