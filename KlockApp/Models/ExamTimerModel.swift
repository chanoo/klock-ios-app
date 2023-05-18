//
//  ExamTimerModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/23.
//

import Foundation

class ExamTimerModel: TimerModel {
    @Published var startTime: String
    @Published var duration: Int
    @Published var questionCount: Int
    @Published var markingTime: Int

    init(id: Int64?, userId: Int64?, seq: Int, type: String?, name: String, startTime: String, duration: Int, questionCount: Int, markingTime: Int) {
        self.startTime = startTime
        self.duration = duration
        self.questionCount = questionCount
        self.markingTime = markingTime
        super.init(id: id, userId: userId, seq: seq, type: type, name: name)
    }
    
    static func toDTO(model: ExamTimerModel) -> ExamTimerDTO {
        return ExamTimerDTO(id: model.id, userId: model.userId, seq: model.seq, type: model.type, name: model.name, startTime: model.startTime, duration: model.duration, questionCount: model.questionCount)
    }
    
    static func from(dto: ExamTimerDTO) -> ExamTimerModel {
        return ExamTimerModel(id: dto.id, userId: dto.userId, seq: dto.seq, type: dto.type, name: dto.name, startTime: dto.startTime, duration: dto.duration, questionCount: dto.questionCount, markingTime: 5)
    }
}
