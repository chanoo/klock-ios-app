//
//  PomodoroTimerModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/23.
//

import Foundation

class PomodoroTimerModel: TimerModel {
    @Published var focusTime: Int
    @Published var breakTime: Int
    @Published var cycleCount: Int

    init(id: Int64?, userId: Int64?, seq: Int, type: String?, name: String, focusTime: Int, breakTime: Int, cycleCount: Int) {
        self.focusTime = focusTime
        self.breakTime = breakTime
        self.cycleCount = cycleCount
        super.init(id: id, userId: userId, seq: seq, type: type, name: name)
    }
    
    static func toDTO(model: PomodoroTimerModel) -> PomodoroTimerDTO {
        return PomodoroTimerDTO(id: model.id, userId: model.userId, seq: model.seq, type: model.type, name: model.name, focusTime: model.focusTime, breakTime: model.breakTime, cycleCount: model.cycleCount)
    }
    
    static func from(dto: PomodoroTimerDTO) -> PomodoroTimerModel {
        return PomodoroTimerModel(id: dto.id, userId: dto.userId, seq: dto.seq, type: dto.type, name: dto.name, focusTime: dto.focusTime, breakTime: dto.breakTime, cycleCount: dto.cycleCount)
    }
}
