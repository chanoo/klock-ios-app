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
    @Published var currentTime: Date
    @Published var startTime: Date
    @Published var isRunning: Bool

    private var cancellableSet: Set<AnyCancellable> = []

    var model: FocusTimerModel
    
    init(model: FocusTimerModel,
         currentTime: Date = Date(),
         startTime: Date = Date(),
         elapsedTime: TimeInterval = 0,
         isRunning: Bool = false
    ) {
        debugPrint("FocusTimerViewModel init", model.name)
        self.model = model
        self.currentTime = currentTime
        self.startTime = startTime
        self.elapsedTime = elapsedTime
        self.isRunning = isRunning

        setupBindings()
    }
    
    func startStudy() {
        isRunning = true
        isStudying = true
        startTime = Date()
        currentTime = Date()
    }

    func stopStudy() {
        isRunning = false
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
