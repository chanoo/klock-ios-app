//
//  CalendarViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/15.
//

import Foundation
import Combine
import Foast

class CalendarViewModel: ObservableObject {
    @Published var studySessions: [String: [StudySessionModel]] = [:]
    @Published var studySessionsOfDay: [StudySessionModel] = []
    @Published var isLoading: Bool = false
    @Published var selectedDate: String
    @Published var totalStudyTime: String
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

    init() {
        self.selectedDate = TimeUtils.formattedDateString(from: Date(), format: "yyyy년 M월 d일 (E)")
        self.totalStudyTime = ""
        self.fetchStudySession()
    }
    
    func fetchStudySession() {
        guard let userId = userModel?.id else {
            Foast.show(message: "회원 정보가 없습니다.")
            return
        }

        isLoading = true
        
        let endDate = Date()
        let endDateStr = TimeUtils.formattedDateString(from: Date(), format: "yyyy-MM-dd")
        let startDate = TimeUtils.subtractDaysFromDate(date: endDate, days: 92)
        let startDateStr = TimeUtils.formattedDateString(from: startDate, format: "yyyy-MM-dd")
        print("period \(startDateStr) ~ \(endDateStr)")

        studySessionRemoteService.fetch(userId: userId, startDate: startDateStr, endDate: endDateStr)
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
            } receiveValue: { [weak self] dto in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    var groupedStudySessions: [String: [StudySessionModel]] = [:]

                    for dtoSession in dto {
                        let session = StudySessionModel.from(dto: dtoSession)
                        let dateString = self.getYMD(date: dtoSession.startTime)
                        if groupedStudySessions[dateString] == nil {
                            groupedStudySessions[dateString] = [session]
                        } else {
                            groupedStudySessions[dateString]?.append(session)
                        }
                    }

                    self.studySessions = groupedStudySessions
                    self.setSelectedDate(endDateStr)
                    let studySessions = self.studySessions[endDateStr] ?? []
                    self.setStudySessionsOfDay(studySessions)
                }
            }
            .store(in: &cancellables)
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
}
