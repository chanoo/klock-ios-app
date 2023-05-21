//
//  ExamTimerModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/23.
//
import Foundation

class ExamTimerModel: TimerModel {
    @Published var startTime: Date
    @Published var duration: Int
    @Published var questionCount: Int
    @Published var markingTime: Int

    init(id: Int64?, userId: Int64?, seq: Int, type: String?, name: String, startTime: Date, duration: Int, questionCount: Int, markingTime: Int) {
        self.startTime = startTime
        self.duration = duration
        self.questionCount = questionCount
        self.markingTime = markingTime
        super.init(id: id, userId: userId, seq: seq, type: type, name: name)
    }
    
    static func toDTO(model: ExamTimerModel) -> ExamTimerDTO {
        let dateFormatter = ISO8601DateFormatter()
        let startTimeString = dateFormatter.string(from: model.startTime)
        
        return ExamTimerDTO(id: model.id, userId: model.userId, seq: model.seq, type: model.type, name: model.name, startTime: startTimeString, duration: model.duration, questionCount: model.questionCount, markingTime: model.markingTime)
    }
    
    static func from(dto: ExamTimerDTO) -> ExamTimerModel {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        guard let date = dateFormatter.date(from: dto.startTime) else {
            fatalError("Failed to convert date string to Date.")
        }

        return ExamTimerModel(id: dto.id, userId: dto.userId, seq: dto.seq, type: dto.type, name: dto.name, startTime: date, duration: dto.duration, questionCount: dto.questionCount, markingTime: dto.markingTime)
    }
}
