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
    var clockViewModel = ClockViewModel(
        currentTime: Date(),
        startTime: Date(),
        elapsedTime: 0,
        studySessions: [],
        isStudying: false,
        isRunning: true
    )
    private var cancellableSet: Set<AnyCancellable> = []

    var model: FocusTimerModel
    
    init(model: FocusTimerModel) {
        debugPrint("FocusTimerViewModel init", model.name)
        self.model = model
        
        setupBindings()
    }
    
    func startStudy() {
        isStudying = true
    }

    func stopStudy() {
        isStudying = false
    }

    func setupBindings() {
        $isStudying.sink { value in
            print("The new value is \(value)")
        }
        .store(in: &cancellableSet)
    }
    
    func elapsedTimeToString() -> String {
        return TimeUtils.elapsedTimeToString(elapsedTime: elapsedTime)
    }

}
