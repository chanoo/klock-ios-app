//
//  TimeTimerViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/15.
//

import Foundation
import SwiftUI
import Combine
import AudioToolbox
import Foast

class TimeTimerViewModel: ObservableObject {

    private let studyStartTimeKey = "studyStartTime"
    @Published var studySessions: [StudySessionModel] = []
    @Published var currentStudySession: StudySessionModel
    @Published var currentTime = Date()
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
        let currentTime = UserDefaults.standard.double(forKey: studyStartTimeKey)
        let startTime = Date(timeIntervalSince1970: currentTime)
        self.currentStudySession = StudySessionModel(id: 0, accountId: 1, startTime: startTime, endTime: now, syncDate: nil)
        calculateElapsedTime()
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

        Foast.show(message: "10초 후 저장됩니다.", duration: 10);

        // 10초 후 실행되는 코드 블록
        stopAndSaveCancellable = Just(())
            .delay(for: .seconds(10), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                
                // endTime - startTime이 30초 이하인 경우 저장하지 않음
                guard endTime.timeIntervalSince(startTime) > 30 else {
                    Foast.show(message: "30초 미만은 기록되지 않습니다.");
                    self?.deleteStudyTime()
                    return
                }
            
                let accountTimer = AccountTimer()
                accountTimer.id = 1
                
                self?.studySessionService.saveStudySession(accountTimer: accountTimer, startTime: startTime, endTime: endTime)
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
            let endTime = Date()
            currentStudySession = StudySessionModel(id: 0, accountId: 1, startTime: startTime, endTime: endTime, syncDate: nil)
        }
        elapsedTime = 0
        calculateElapsedTime()
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

    func hourAngle(for date: Date) -> Double {
        let hour = Calendar.current.component(.hour, from: date)
        let minute = Calendar.current.component(.minute, from: date)
        return (Double(hour % 12) + Double(minute) / 60) / 12 * 360
    }

    func minuteAngle(for date: Date) -> Double {
        let minute = Calendar.current.component(.minute, from: date)
        let second = Calendar.current.component(.second, from: date)
        return (Double(minute) + Double(second) / 60) / 60 * 360
    }

    func secondAngle(for date: Date) -> Double {
        let second = Calendar.current.component(.second, from: date)
        return Double(second) / 60 * 360
    }

}
