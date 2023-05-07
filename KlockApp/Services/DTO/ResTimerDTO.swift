// ResTimerDTO.swift
// KlockApp
// 작성자: 성찬우
// 작성일: 2023/05/02

import Foundation

// TimerDTO 프로토콜 정의
protocol TimerDTO: Codable {}

// 시험 타이머 구조체 정의
struct ExamTimerDTO: Codable, TimerDTO {
    let id: Int64?
    let userId: Int
    let seq: Int
    let type: String?
    let name: String
    let startTime: String
    let duration: Int
    let questionCount: Int
}

// 포모도로 타이머 구조체 정의
struct PomodoroTimerDTO: Codable, TimerDTO {
    let id: Int64?
    let userId: Int
    let seq: Int
    let type: String?
    let name: String
    let focusTime: Int
    let restTime: Int
    let cycleCount: Int
}

// 집중력 타이머 구조체 정의
struct FocusTimerDTO: Codable, TimerDTO {
    let id: Int64?
    let userId: Int
    let seq: Int
    let type: String?
    let name: String
}

// 타이머 항목 디코딩 함수
func decodeTimerItem(from data: Data) throws -> TimerDTO? {
    let item = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    guard let itemType = item?["type"] as? String else { return nil }

    switch itemType {
    case "exam":
        return try JSONDecoder().decode(ExamTimerDTO.self, from: data)
    case "pomodoro":
        return try JSONDecoder().decode(PomodoroTimerDTO.self, from: data)
    case "focus":
        return try JSONDecoder().decode(FocusTimerDTO.self, from: data)
    default:
        return nil
    }
}

// 여러 타이머 항목 디코딩 함수
func decodeTimerItems(from data: Data) throws -> [TimerDTO] {
    let items = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
    var timerItems: [TimerDTO] = []

    for item in items ?? [] {
        let jsonData = try JSONSerialization.data(withJSONObject: item, options: [])
        if let timerItem = try decodeTimerItem(from: jsonData) {
            timerItems.append(timerItem)
        }
    }

    return timerItems
}
