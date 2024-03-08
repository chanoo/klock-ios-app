//
//  CalendarViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/15.
//

import Foundation
import Combine
import Foast
import UIKit

class CalendarViewModel: ObservableObject {
    @Published var studySessions: [String: [StudySessionModel]] = [:]
    @Published var studySessionsOfDay: [StudySessionModel] = []
    @Published var isLoading: Bool = true
    @Published var selectedDate: String = TimeUtils.formattedDateString(from: Date(), format: "yyyy년 M월 d일 (E)")
    @Published var totalStudyTime: String = ""
    @Published var becomeFirstResponder: Bool = false
    @Published var studySessionModel: StudySessionModel = StudySessionModel(id: nil, userId: 0, startTime: Date(), endTime: Date(), timerName: "", timerType: "")
    private let studySessionRemoteService = Container.shared.resolve(StudySessionRemoteServiceProtocol.self)
    private let accountTimerService = Container.shared.resolve(AccountTimerServiceProtocol.self)
    private let accountService = Container.shared.resolve(AccountLocalServiceProtocol.self)
    private var cancellables = Set<AnyCancellable>()
    // DateFormatter를 프로퍼티로 추가합니다.
    lazy var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    private let userModel = UserModel.load()
    private let apiQueue = DispatchQueue(label: "app.klockApp.api.queue")
    
    func updateStudySession() {
        apiQueue.async { [weak self] in
            guard let self = self, let id = studySessionModel.id else { return }
            
            let startTime = TimeUtils.formattedDateString(from: studySessionModel.startTime, format: "yyyy-MM-dd'T'HH:mm:ss")
            let endTime = studySessionModel.endTime.map { TimeUtils.formattedDateString(from: $0, format: "yyyy-MM-dd'T'HH:mm:ss") }

            let request = StudySessionUpdateReqDTO(
                id: id,
                userId: studySessionModel.userId,
                startTime: startTime,
                endTime: endTime,
                timerName: studySessionModel.timerName,
                timerType: studySessionModel.timerType
            )
            
            self.studySessionRemoteService.update(id: id, data: request)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Error updating study session: \(error)")
                    }
                }, receiveValue: { _ in
                    // Handle the successful update, if needed
                })
                .store(in: &self.cancellables)
        }
    }
    
    func fetchStudySession() {
        apiQueue.async { [weak self] in
            guard let self = self, let userId = userModel?.id else {
                Foast.show(message: "회원 정보가 없습니다.")
                return
            }
            
            let endDate = Date()
            let endDateStr = TimeUtils.formattedDateString(from: endDate, format: "yyyy-MM-dd")
            let startDate = TimeUtils.subtractDaysFromDate(date: endDate, days: 92)
            let startDateStr = TimeUtils.formattedDateString(from: startDate, format: "yyyy-MM-dd")
            print("period \(startDateStr) ~ \(endDateStr)")

            studySessionRemoteService.fetch(userId: userId, startDate: startDateStr, endDate: endDateStr)
                .sink(receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        print("Error fetching study sessions: \(error)")
                    }
                    DispatchQueue.main.async {
                        self?.isLoading = false
                    }
                }, receiveValue: { [weak self] dto in
                    DispatchQueue.main.async {
                        let groupedStudySessions = dto.reduce(into: [String: [StudySessionModel]]()) { (acc, dtoSession) in
                            let session = StudySessionModel.from(dto: dtoSession)
                            let dateString = self?.getYMD(date: dtoSession.startTime) ?? ""
                            acc[dateString, default: []].append(session)
                        }

                        self?.studySessions = groupedStudySessions
                        self?.setSelectedDate(endDateStr)
                        self?.setStudySessionsOfDay(self?.studySessions[endDateStr] ?? [])
                    }
                })
                .store(in: &self.cancellables)
        }
    }

    func getYMD(date: String) -> String {
        return String(date.prefix(10))
    }

    func sortedDates() -> [String] {
        return Array(studySessions.keys).sorted { (date1, date2) -> Bool in
            guard let date1Obj = TimeUtils.dateFromString(dateString: date1, format: "yyyy-MM-dd"), let date2Obj = TimeUtils.dateFromString(dateString: date2, format: "yyyy-MM-dd") else {
                return false
            }
            return date1Obj > date2Obj
        }
    }
    
    func setStudySessionsOfDay(_ studySessionModel: [StudySessionModel]) {
        studySessionsOfDay = studySessionModel
    }
    
    func setSelectedDate(_ dateStr: String) {
        let date  = TimeUtils.dateFromString(dateString: dateStr, format: "yyyy-MM-dd")
        selectedDate = TimeUtils.formattedDateString(from: date ?? Date(), format: "yyyy년 M월 d일 (E)")
        if let sessions = self.studySessions[dateStr] {
            let totalDuration = sessions.reduce(0) { $0 + $1.duration }
            totalStudyTime = TimeUtils.elapsedTimeToString(elapsedTime: totalDuration)
        } else {
            totalStudyTime = "00:00:00"
        }
    }
    
    func hideKeyboard() {
        becomeFirstResponder = false
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
