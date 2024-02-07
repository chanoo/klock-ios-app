//
//  TimerManager.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/05/13.
//

import Foundation
import Combine

class TimerManager {
    var timerModels: [TimerModel] = []
    private var cancellables: Set<AnyCancellable> = []
    
    // Service objects
    private let timerRemoteService = Container.shared.resolve(TimerRemoteServiceProtocol.self)
    private let focusTimerRemoteService = Container.shared.resolve(FocusTimerRemoteServiceProtocol.self)
    private let pomodoroTimerRemoteService = Container.shared.resolve(PomodoroTimerRemoteServiceProtocol.self)
    private let examTimerRemoteService = Container.shared.resolve(ExamTimerRemoteServiceProtocol.self)
    private let autoTimerRemoteService = Container.shared.resolve(AutoTimerRemoteServiceProtocol.self)

    func fetchTimers(completion: @escaping ([TimerModel]) -> Void) {
        timerRemoteService.fetch()
            .sink { [weak self] completion in
                guard self != nil else { return }
                switch completion {
                case .failure(let error):
                    print("Error fetching study sessions: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] userTimers in
                guard let self = self else { return }
                self.timerModels = userTimers.compactMap { dto in
                    if let timerTypeStr = dto.type, let timerType = TimerType(rawValue: timerTypeStr) {
                        switch timerType {
                        case .focus:
                            return FocusTimerModel.from(dto: dto as! FocusTimerDTO)
                        case .pomodoro:
                            return PomodoroTimerModel.from(dto: dto as! PomodoroTimerDTO)
                        case .exam:
                            return ExamTimerModel.from(dto: dto as! ExamTimerDTO)
                        case .auto:
                            return AutoTimerModel.from(dto: dto as! AutoTimerDTO)
                        }
                    } else {
                        return nil
                    }
                }
                completion(self.timerModels)
            }
            .store(in: &cancellables)
    }
    
    // Add Timer related functions
    func deleteTimer(model: TimerModel, completion: @escaping (Bool) -> Void) {
        if let timerTypeStr = model.type, let timerType = TimerType(rawValue: timerTypeStr) {
            switch timerType {
            case .focus:
                self.focusTimerRemoteService.delete(id: model.id!)
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .failure(let error):
                            print("Error deleting focus timer: \(error)")
                        case .finished:
                            break
                        }
                    }, receiveValue: { _ in
                        completion(true)
                    })
                    .store(in: &self.cancellables)
                break
            case .pomodoro:
                self.pomodoroTimerRemoteService.delete(id: model.id!)
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .failure(let error):
                            print("Error deleting focus timer: \(error)")
                        case .finished:
                            break
                        }
                    }, receiveValue: { _ in
                        completion(true)
                    })
                    .store(in: &self.cancellables)
                break
            case .exam:
                self.examTimerRemoteService.delete(id: model.id!)
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .failure(let error):
                            print("Error deleting focus timer: \(error)")
                        case .finished:
                            break
                        }
                    }, receiveValue: { _ in
                        completion(true)
                    })
                    .store(in: &self.cancellables)
                break
            case .auto:
                self.autoTimerRemoteService.delete(id: model.id!)
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .failure(let error):
                            print("Error deleting auto timer: \(error)")
                        case .finished:
                            break
                        }
                    }, receiveValue: { _ in
                        completion(true)
                    })
                    .store(in: &self.cancellables)
                break
            }
        }
    }
    
    func addTimer(type: String, completion: @escaping (TimerModel?) -> Void) {
        let seq = 1
        guard let timerType = TimerType(rawValue: type) else { return }
        switch timerType {
        case .focus:
            let req = ReqFocusTimer(seq: seq, name: "집중시간 타이머")
            focusTimerRemoteService.create(data: req)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error creating focus timer: \(error)")
                    case .finished:
                        break
                    }
                }, receiveValue: { createdTimer in
                    let model = FocusTimerModel.from(dto: createdTimer)
                    completion(model)
                })
                .store(in: &cancellables)
        case .pomodoro:
            let req = ReqPomodoroTimer(seq: seq, name: "뽀모도로 타이머", focusTime: 25, breakTime: 5, cycleCount: 4)
            pomodoroTimerRemoteService.create(data: req)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error creating pomodoro timer: \(error)")
                    case .finished:
                        break
                    }
                }, receiveValue: { createdTimer in
                    let model = PomodoroTimerModel.from(dto: createdTimer)
                    completion(model)
                })
                .store(in: &cancellables)
        case .exam:
            let req = ReqExamTimer(seq: seq, name: "시험시간 타이머", startTime: "2023-01-01T08:40:00.000000", duration: 80, questionCount: 45)
            examTimerRemoteService.create(data: req)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error creating exam timer: \(error)")
                    case .finished:
                        break
                    }
                }, receiveValue: { createdTimer in
                    let model = ExamTimerModel.from(dto: createdTimer)
                    completion(model)
                })
                .store(in: &cancellables)
        case .auto:
            let req = ReqAutoTimer(seq: seq, name: "자동측정 타이머")
            autoTimerRemoteService.create(data: req)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error creating auto timer: \(error)")
                    case .finished:
                        break
                    }
                }, receiveValue: { createdTimer in
                    let model = AutoTimerModel.from(dto: createdTimer)
                    completion(model)
                })
                .store(in: &cancellables)
        }
    }
    
    func updateTimer(type: String, id: Int64, model: TimerModel, completion: @escaping (TimerModel?) -> Void) {
        let seq = 1
        guard let timerType = TimerType(rawValue: type) else { return }
        switch timerType {
        case .focus:
            let dto = FocusTimerModel.toDTO(model: model as! FocusTimerModel)
            let req = ReqFocusTimer(seq: dto.seq, name: dto.name)
            focusTimerRemoteService.update(id: id, data: req)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error creating focus timer: \(error)")
                    case .finished:
                        break
                    }
                }, receiveValue: { createdTimer in
                    let model = FocusTimerModel.from(dto: createdTimer)
                    completion(model)
                })
                .store(in: &cancellables)
        case .pomodoro:
            let dto = PomodoroTimerModel.toDTO(model: model as! PomodoroTimerModel)
            let req = ReqPomodoroTimer(seq: dto.seq, name: dto.name, focusTime: dto.focusTime, breakTime: dto.breakTime, cycleCount: dto.cycleCount)
            pomodoroTimerRemoteService.update(id: id, data: req)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error creating pomodoro timer: \(error)")
                    case .finished:
                        break
                    }
                }, receiveValue: { createdTimer in
                    let model = PomodoroTimerModel.from(dto: createdTimer)
                    completion(model)
                })
                .store(in: &cancellables)
        case .exam:
            let req = ReqExamTimer(seq: seq, name: "국어", startTime: "2023-01-01T08:40:00.000000", duration: 80, questionCount: 45)
            examTimerRemoteService.update(id: id, data: req)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error creating exam timer: \(error)")
                    case .finished:
                        break
                    }
                }, receiveValue: { createdTimer in
                    let model = ExamTimerModel.from(dto: createdTimer)
                    completion(model)
                })
                .store(in: &cancellables)
        case .auto:
            let dto = AutoTimerModel.toDTO(model: model as! AutoTimerModel)
            let req = ReqAutoTimer(seq: dto.seq, name: dto.name)
            autoTimerRemoteService.update(id: id, data: req)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error creating focus timer: \(error)")
                    case .finished:
                        break
                    }
                }, receiveValue: { createdTimer in
                    let model = AutoTimerModel.from(dto: createdTimer)
                    completion(model)
                })
                .store(in: &cancellables)
        }
    }
}
