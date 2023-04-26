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
import UniformTypeIdentifiers

class TimeTimerViewModel: ObservableObject {
    private let studyStartTimeKey = "studyStartTime"
    
    @Published var studySessions: [StudySessionModel] = []
    @Published var currentStudySession: StudySessionModel
    @Published var elapsedTime: TimeInterval = 0
    @Published var clockModel: ClockModel
    @Published var isDark: Bool = false
    @Published var isLoading: Bool = false
    @Published var timerCardViews: [AnyView] = []
    @Published var isShowingClockModal = false
    @Published var isStudying: Bool = false

    private var cancellables: Set<AnyCancellable> = []
    private let accountService = Container.shared.resolve(AccountServiceProtocol.self)
    private let accountTimerService = Container.shared.resolve(AccountTimerServiceProtocol.self)
    private let studySessionService = Container.shared.resolve(StudySessionServiceProtocol.self)
    private let proximityAndOrientationService = Container.shared.resolve(ProximityAndOrientationServiceProtocol.self)
    
    init(clockModel: ClockModel) {
        self.clockModel = clockModel
        self.studySessions = []
        let now = Date()
        let currentTime = UserDefaults.standard.double(forKey: studyStartTimeKey)
        let startTime = Date(timeIntervalSince1970: currentTime)
        self.currentStudySession = StudySessionModel(id: 0, accountId: 1, startTime: startTime, endTime: now, syncDate: nil)
        
        calculateElapsedTime()
        setupSensor()
        fetchTimers()
        observeIsStudyingChanges()
    }
    
    private func setupSensor() {
        proximityAndOrientationService.setupSensor()
            .assign(to: \.isDark, on: self)
            .store(in: &cancellables)
    }

    func playVibration() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }

    func fetchTimers() {
        isLoading = true
        accountTimerService.fetch()
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    print("Error fetching study sessions: \(error)")
                case .finished:
                    break
                }
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            } receiveValue: { [weak self] accountTimers in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.timerCardViews = accountTimers.map { accountTimer in
                        self.viewFor(timerType: accountTimer.type.rawValue)
                    }.reversed()
                }
            }
            .store(in: &cancellables)
    }
    
    func viewFor(timerType: String?) -> AnyView {
        if let type = timerType {
            switch type {
            case "study":
                return AnyView(StudyTimeTimerView())
            case "exam":
                return AnyView(ExamTimeTimerView())
            case "pomodoro":
                return AnyView(PomodoroTimerView())
            default:
                break
            }
        }
        return AnyView(EmptyView())
    }
    
    func addTimer(type: String) {
        self.accountTimerService.create(accountID: 1, type: type, active: true)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { accountTimer in
                print("accountTimer: \(String(describing: accountTimer.type))")
                let view = self.viewFor(timerType: accountTimer.type.rawValue)
                self.timerCardViews.insert(view, at: 0)
            })
            .store(in: &cancellables)
    }
    
    private func observeIsStudyingChanges() {
        $isStudying
            .sink { [weak self] isStudying in
                guard let self = self else { return }
                print("isStudying 값이 변경되었습니다: \(isStudying)")
                if isStudying {
                    self.startStudySession()
                } else {
                    self.stopAndSaveStudySessionIfNeeded(shouldSave: !isStudying)
                }
            }
            .store(in: &cancellables)
    }

    private func stopAndSaveStudySessionIfNeeded(shouldSave: Bool) {
        updateElapsedTime()
        let startTime = Date().addingTimeInterval(-elapsedTime)
        let endTime = Date()

        if shouldSave {
            guard endTime.timeIntervalSince(startTime) > 10 else {
                Foast.show(message: "10초 미만은 기록되지 않습니다.")
                removeStudyStartTime()
                return
            }

            studySessionService.save(accountID: 1, accountTimerID: 1, startTime: startTime, endTime: endTime)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error saving study session: \(error)")
                    case .finished:
                        print("Study session saved successfully")
                    }
                }, receiveValue: { [weak self] _ in
                    self?.removeStudyStartTime()
                })
                .store(in: &cancellables)
        } else {
            removeStudyStartTime()
        }
    }

    private func startStudySession() {
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
        updateElapsedTime()
    }

    private func updateElapsedTime() {
        elapsedTime = Date().timeIntervalSince(currentStudySession.startTime)
    }

    private func removeStudyStartTime() {
        UserDefaults.standard.removeObject(forKey: studyStartTimeKey)
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

    func toggleClockModal() {
        isShowingClockModal.toggle()
    }
    
    func elapsedTimeToString() -> String {
        return TimeUtils.elapsedTimeToString(elapsedTime: elapsedTime)
    }
    
    func angleForTime(date: Date) -> Double {
        return TimeUtils.angleForTime(date: date)
    }

    func dropDelegate(for index: Int) -> TimerDropDelegate {
        TimerDropDelegate(viewModel: self, index: index)
    }

    func removeTimerCard(at index: Int) {
        timerCardViews.remove(at: index)
    }

    func insertTimerCard(_ timerCard: AnyView, at index: Int) {
        timerCardViews.insert(timerCard, at: index)
    }
    
    struct TimerDropDelegate: DropDelegate {
        let viewModel: TimeTimerViewModel
        let index: Int
        
        func performDrop(info: DropInfo) -> Bool {
            if let source = info.itemProviders(for: [.text]).first {
                source.loadItem(forTypeIdentifier: UTType.text.identifier, options: nil) { (data, error) in
                    if let data = data as? Data, let sourceIndex = Int(String(data: data, encoding: .utf8) ?? "") {
                        DispatchQueue.main.async {
                            viewModel.removeTimerCard(at: sourceIndex)
                            let sourceView = viewModel.timerCardViews.remove(at: sourceIndex)
                            viewModel.insertTimerCard(sourceView, at: index)
                        }
                    }
                }
                return true
            }
            return false
        }
    }
}
