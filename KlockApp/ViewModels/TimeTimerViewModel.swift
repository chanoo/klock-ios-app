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
    // Constants
    private let studyStartTimeKey = "studyStartTime"
    
    // Managers
    private let timerManager = Container.shared.resolve(TimerManager.self)
    
    // Published properties
    @Published var studySessions: [StudySessionModel] = []
    @Published var currentStudySession: StudySessionModel
    @Published var elapsedTime: TimeInterval = 0
    @Published var isDark: Bool = false
    @Published var isLoading: Bool = false
    @Published var timerCardViews: [AnyView] = []
    @Published var isStudying: Bool = false
    @Published var isShowingClockModal = false
    
    // Service objects
    private let timerRemoteService = Container.shared.resolve(TimerRemoteServiceProtocol.self)
    private let focusTimerRemoteService = Container.shared.resolve(FocusTimerRemoteServiceProtocol.self)
    private let pomodoroTimerRemoteService = Container.shared.resolve(PomodoroTimerRemoteServiceProtocol.self)
    private let examTimerRemoteService = Container.shared.resolve(ExamTimerRemoteServiceProtocol.self)
    private let proximityAndOrientationService = Container.shared.resolve(ProximityAndOrientationServiceProtocol.self)
    private let studySessionService = Container.shared.resolve(StudySessionServiceProtocol.self)
    
    // Other properties
    var timerModels: [TimerModel] = []
    private var cancellables: Set<AnyCancellable> = []

    init() {
        let now = Date()
        let currentTime = UserDefaults.standard.double(forKey: studyStartTimeKey)
        let startTime = Date(timeIntervalSince1970: currentTime)
        self.currentStudySession = StudySessionModel(id: 0, accountId: 1, startTime: startTime, endTime: now, syncDate: nil)
        setupSensor()
        timerManager.fetchTimers { [weak self] timerModels in
            guard let self = self else { return }
            self.timerModels = timerModels
            self.timerCardViews = self.timerModels.map { self.viewFor(timer: $0) }
        }
        observeIsStudyingChanges()
        calculateElapsedTime()
    }

    // MARK: - Sensor setup
    private func setupSensor() {
        proximityAndOrientationService.setupSensor()
            .assign(to: \.isDark, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: - Timer view creation
    func viewFor(timer: TimerModel) -> AnyView {
        switch timer {
        case let focusTimer as FocusTimerModel:
            return AnyView(FocusTimerView(model: focusTimer))
        case let pomodoroTimer as PomodoroTimerModel:
            return AnyView(PomodoroTimerView(model: pomodoroTimer))
        case let examTimer as ExamTimerModel:
            return AnyView(ExamTimeTimerView(model: examTimer))
        default:
            return AnyView(EmptyView())
        }
    }

    // MARK: - Study Session Management
    private func observeIsStudyingChanges() {
        $isStudying
            .sink { [weak self] isStudying in
                isStudying ? self?.startStudySession() : self?.stopAndSaveStudySessionIfNeeded()
            }
            .store(in: &cancellables)
    }

    func calculateElapsedTime() {
        guard let startTime = UserDefaults.standard.object(forKey: studyStartTimeKey) as? Date else { return }
        elapsedTime += Date().timeIntervalSince(startTime)
    }
    
    private func startStudySession() {
        let currentTime = UserDefaults.standard.double(forKey: studyStartTimeKey)
        let now = Date()
        let startTime = currentTime == 0 ? now : Date(timeIntervalSince1970: currentTime)
        currentStudySession = StudySessionModel(id: 0, accountId: 1, startTime: startTime, endTime: now, syncDate: nil)
        elapsedTime = 0
        updateElapsedTime()
    }

    private func stopAndSaveStudySessionIfNeeded() {
        updateElapsedTime()
        let startTime = Date().addingTimeInterval(-elapsedTime)
        let endTime = Date()
        let sessionDuration = endTime.timeIntervalSince(startTime)

        guard sessionDuration > 10 else {
            Foast.show(message: "10초 미만은 기록되지 않습니다.")
            removeStudyStartTime()
            return
        }
        
        saveStudySession(accountID: 1, accountTimerID: 1, startTime: startTime, endTime: endTime)
    }

    private func saveStudySession(accountID: Int64, accountTimerID: Int64, startTime: Date, endTime: Date) {
        studySessionService.save(accountID: accountID, accountTimerID: accountTimerID, startTime: startTime, endTime: endTime)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error saving study session: \(error)")
                case .finished:
                    print("Study session saved successfully")
                    self.removeStudyStartTime()
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }

    // MARK: - Study Session Helpers
    private func removeStudyStartTime() {
        UserDefaults.standard.removeObject(forKey: studyStartTimeKey)
    }
    
    func delete(model: TimerModel) {
        timerManager.deleteTimer(model: model) { success in
            if let index = self.timerModels.firstIndex(where: { $0.type == model.type && $0.id == model.id }) {
                self.timerModels.remove(at: index)
                self.timerCardViews.remove(at: index)
                Foast.show(message: "삭제 되었습니다.")
            }
        }
    }

    func addTimer(type: String) {
        timerManager.addTimer(type: type) { optionalModel in
            DispatchQueue.main.async {
                guard let model = optionalModel else {
                    print("Error: Timer model is nil.")
                    return
                }
                let view = self.viewFor(timer: model)
                self.timerModels.insert(model, at: 0)
                self.timerCardViews.insert(view, at: 0)
            }
        }
    }

    func deleteStudyTime() {
        elapsedTime = 0
        UserDefaults.standard.removeObject(forKey: studyStartTimeKey)
    }

    // MARK: - Other methods
    func updateTime() {
        let now = Date()
        currentStudySession = StudySessionModel(
            id: currentStudySession.id,
            accountId: currentStudySession.accountId,
            startTime: currentStudySession.startTime,
            endTime: now,
            syncDate: nil)
    }
    
    private func updateElapsedTime() {
        elapsedTime = Date().timeIntervalSince(currentStudySession.startTime)
    }
    
    func playVibration() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
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

    // MARK: - Timer Card Management
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
                            self.viewModel.handleDrop(sourceIndex: sourceIndex, destinationIndex: self.index)
                        }
                    }
                }
                return true
            }
            return false
        }
    }
    
    func handleDrop(sourceIndex: Int, destinationIndex: Int) {
        guard sourceIndex != destinationIndex else { return }
        let sourceView = timerCardViews.remove(at: sourceIndex)
        timerCardViews.insert(sourceView, at: destinationIndex)
    }
}
