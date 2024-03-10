// ResTimerDTO.swift
// KlockApp
// 작성자: 성찬우
// 작성일: 2023/05/02

import Foundation

// TimerDTO 프로토콜 정의
protocol TimerDTO: Codable {
    var type: String? { get }
}

// 시험 타이머 구조체 정의
struct ReqExamTimer: Codable {
    let seq: Int
    let name: String
    let startTime: String
    let duration: Int
    let questionCount: Int
}

struct ExamTimerDTO: Codable, TimerDTO {
    var id: Int64
    var userId: Int64? = nil
    let seq: Int
    var type: String? = TimerType.exam.rawValue
    let name: String
    let startTime: String
    let duration: Int
    let questionCount: Int
    let markingTime: Int
}

// 포모도로 타이머 구조체 정의
struct ReqPomodoroTimer: Codable {
    let seq: Int
    let name: String
    let focusTime: Int
    let breakTime: Int
    let cycleCount: Int
}

struct PomodoroTimerDTO: Codable, TimerDTO {
    let id: Int64
    let userId: Int64?
    let seq: Int
    let type: String?
    let name: String
    let focusTime: Int
    let breakTime: Int
    let cycleCount: Int
}

// 집중력 타이머 구조체 정의
struct ReqFocusTimer: Codable {
    let seq: Int
    let name: String
}

struct FocusTimerDTO: Codable, TimerDTO {
    let id: Int64
    let userId: Int64?
    let seq: Int
    let type: String?
    let name: String
}

struct ReqAutoTimer: Codable {
    let seq: Int
    let name: String
}

struct AutoTimerDTO: Codable, TimerDTO {
    let id: Int64
    let userId: Int64?
    let seq: Int
    let type: String?
    let name: String
}

// 타이머 항목 디코딩 함수
func decodeTimerItem(from data: Data) throws -> TimerDTO? {
    let item = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    guard let itemTypeStr = item?["type"] as? String else { return nil }

    if let timerType = TimerType(rawValue: itemTypeStr) {
        switch timerType {
        case .focus:
            return try JSONDecoder().decode(FocusTimerDTO.self, from: data)
        case .pomodoro:
            return try JSONDecoder().decode(PomodoroTimerDTO.self, from: data)
        case .exam:
            return try JSONDecoder().decode(ExamTimerDTO.self, from: data)
        case .auto:
            return try JSONDecoder().decode(AutoTimerDTO.self, from: data)
        }
    } else {
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
