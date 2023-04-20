//
//  ClockViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/15.
//

import Foundation
import SwiftUI
import Combine
import AudioToolbox

class ClockViewModel: ObservableObject {

    private let studyStartTimeKey = "studyStartTime"
    @Published var studySessions: [StudySessionModel] = []
    @Published var currentStudySession: StudySessionModel

    @Published var elapsedTime: TimeInterval = 0
    @Published var clockModel: ClockModel
    private var cancellable: AnyCancellable?
    private var stopAndSaveCancellable: AnyCancellable?

    @Published var isDark: Bool = false

    private let studySessionService: StudySessionServiceProtocol = Container.shared.resolve(StudySessionServiceProtocol.self)
    private let proximityAndOrientationService: ProximityAndOrientationServiceProtocol = Container.shared.resolve(ProximityAndOrientationServiceProtocol.self)

    private var orientationObserver: NSObjectProtocol?
    var cancellables: Set<AnyCancellable> = []

    init(clockModel: ClockModel) {
        self.clockModel = clockModel
        self.studySessions = []
        let now = Date()
        self.currentStudySession = StudySessionModel(id: 0, accountId: 1, startTime: now, endTime: now, syncDate: nil)
//        self.studySessions = generateSampleStudySessions()
        setupSensor()
    }

    private func setupSensor() {
        cancellable = proximityAndOrientationService.setupSensor()
            .assign(to: \.isDark, on: self)
    }

    func playVibration() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }

    func stopAndSaveStudySession() {
        let startTime = Date().addingTimeInterval(-elapsedTime)
        let endTime = Date()

        // 10초 후 실행되는 코드 블록
        stopAndSaveCancellable = Just(())
            .delay(for: .seconds(10), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                
                // endTime - startTime이 30초 이하인 경우 저장하지 않음
                guard endTime.timeIntervalSince(startTime) > 30 else {
                    self?.deleteStudyTime()
                    return
                }
                
                self?.studySessionService.saveStudySession(startTime: startTime, endTime: endTime)
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .failure(let error):
                            print("Error saving study session: \(error)")
                        case .finished:
                            print("Study session saved successfully")
                        }
                    }, receiveValue: { _ in
                        self?.deleteStudyTime()
                    })
                    .store(in: &self!.cancellables)
            })
    }
    
    func stopAndSaveCancel() {
        // 이미 실행 중인 10초 지연 저장 작업이 있다면 취소
        stopAndSaveCancellable?.cancel()
        stopAndSaveCancellable = nil
    }

    func loadStudyTime() {
        stopAndSaveCancel()
        let currentTime = UserDefaults.standard.double(forKey: studyStartTimeKey)
        if currentTime == 0 {
            let now = Date()
            UserDefaults.standard.set(now.timeIntervalSince1970, forKey: studyStartTimeKey)
            currentStudySession = StudySessionModel(id: 0, accountId: 1, startTime: now, endTime: now, syncDate: nil)
        } else {
            let startTime = Date(timeIntervalSince1970: currentTime)
            currentStudySession = StudySessionModel(id: 0, accountId: 1, startTime: startTime, endTime: startTime, syncDate: nil)
        }

        // 이전 elapsedTime을 초기화
        elapsedTime = 0

        calculateElapsedTime()
        debugPrint("elapsedTime", elapsedTime)
    }


    func deleteStudyTime() {
        elapsedTime = 0
        UserDefaults.standard.removeObject(forKey: studyStartTimeKey)
    }

    func calculateElapsedTime() {
        let startTimeKey = UserDefaults.standard.double(forKey: studyStartTimeKey)
        if startTimeKey != 0 {
            let currentTime = Date().timeIntervalSince1970
            let timeDifference = currentTime - startTimeKey
            elapsedTime += timeDifference
        }
    }
    
    func updateTime() {
        let now = Date()
        currentStudySession = StudySessionModel(
            id: currentStudySession.id,
            accountId: currentStudySession.accountId,
            startTime: currentStudySession.startTime,
            endTime: now,
            syncDate: nil)
    }
    
    func elapsedTimeToString() -> String {
        return TimeUtils.elapsedTimeToString(elapsedTime: elapsedTime)
    }
    
    func angleForTime(date: Date) -> Double {
        return TimeUtils.angleForTime(date: date)
    }

    func generateSampleStudySessions() -> [StudySessionModel] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        let sampleTimes: [(start: String, end: String)] = [
            (start: "2023/04/15 08:00", end: "2023/04/15 08:50"),
            (start: "2023/04/15 09:00", end: "2023/04/15 09:50"),
            (start: "2023/04/15 11:00", end: "2023/04/15 11:50"),
            (start: "2023/04/15 13:00", end: "2023/04/15 13:50"),
            (start: "2023/04/15 15:00", end: "2023/04/15 15:50"),
            (start: "2023/04/15 16:00", end: "2023/04/15 16:50"),
            (start: "2023/04/15 18:00", end: "2023/04/15 18:50"),
            (start: "2023/04/15 19:00", end: "2023/04/15 19:50"),
            (start: "2023/04/15 20:00", end: "2023/04/15 20:50"),
            (start: "2023/04/15 21:00", end: "2023/04/15 23:59")
        ]

        // 수정된 부분
        var sampleStudySessions: [StudySessionModel] = []
        
        for i in 0..<sampleTimes.count {
            if let startTime = dateFormatter.date(from: sampleTimes[i].start),
               let endTime = dateFormatter.date(from: sampleTimes[i].end) {
                let studySession = StudySessionModel(id: Int64(i), accountId: 1, startTime: startTime, endTime: endTime, syncDate: nil)
                sampleStudySessions.append(studySession)
            }
        }

        return sampleStudySessions
    }

    func updateClockSize(_ size: CGSize) {
        clockModel.clockSize = size
    }

}

