//
//  StudySessionsByDateView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/19.
//

import SwiftUI

struct StudySessionsByDateView: View {
    @StateObject var viewModel: CalendarViewModel = Container.shared.resolve(CalendarViewModel.self)
    @State private var showAlert = false

    var body: some View {
        List {
            ForEach(Array(viewModel.studySessions.keys).sorted(by: { (date1, date2) -> Bool in
                guard let date1Obj = viewModel.dateFromString(date1), let date2Obj = viewModel.dateFromString(date2) else {
                    return false
                }
                return date1Obj > date2Obj
            }), id: \.self) { dateString in
                Section(header: Text(dateString)) {
                    ForEach(viewModel.studySessions[dateString]!, id: \.id) { studySession in
                        StudySessionRow(studySession: studySession)
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("삭제"),
                    message: Text("공부 기록을 삭제하시겠습니까?"),
                    primaryButton: .destructive(Text("삭제")) {
                        viewModel.deleteStoredStudySessions()
                    },
                    secondaryButton: .cancel())
            }
        }
        .navigationBarTitle("공부 시간")
        .navigationBarItems(
            trailing: Button(action: {showAlert = true}) {
                Image(systemName: "trash")
            })
    }
}

struct StudySessionRow: View {
    let studySession: StudySessionModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(studySession.id ?? 0). \(timeString(from: studySession.startTime)) ~ \(timeString(from: studySession.endTime))")
            Text("\(timeIntervalToHMS(timeInterval: studySession.sessionDuration))")
        }
    }
    
    func timeIntervalToHMS(timeInterval: TimeInterval) -> String {
        let totalSeconds = Int(timeInterval)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    private func timeString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}
