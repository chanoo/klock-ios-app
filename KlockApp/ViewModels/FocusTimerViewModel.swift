//
//  FocusTimerViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/05/16.
//

import Foundation
import Combine

class FocusTimerViewModel: ObservableObject {
    
    @Published var elapsedTime: TimeInterval = 0
    @Published var isStudying: Bool = false

    var model: FocusTimerModel
    
    init(model: FocusTimerModel) {
        self.model = model
    }

}
