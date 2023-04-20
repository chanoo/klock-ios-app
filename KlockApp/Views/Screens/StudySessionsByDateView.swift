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
    @State private var showGenerateSampleDataSheet = false

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
                    .onDelete(perform: { indexSet in
                        guard let index = indexSet.first,
                              let studySession = viewModel.studySessions[dateString]?[index],
                              let id = studySession.id else {
                            return
                        }
                        viewModel.deleteStudySessionById(id: id)
                    })
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
            leading: Button(action: { showGenerateSampleDataSheet = true }) {
                Image(systemName: "arrow.clockwise.circle")
            },
            trailing: Button(action: { showAlert = true }) {
                Image(systemName: "trash")
            })
        .sheet(isPresented: $showGenerateSampleDataSheet) {
            GenerateSampleDataView(viewModel: viewModel, isPresented: $showGenerateSampleDataSheet)
        }

    }
}

struct GenerateSampleDataView: View {
    @ObservedObject var viewModel: CalendarViewModel
    @Binding var isPresented: Bool
    @State private var startDate = Date()
    @State private var endDate = Date()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    
                    Spacer()
                    
                    DatePicker("시작 날짜", selection: $startDate, displayedComponents: .date)
                        .padding()
                        .datePickerStyle(GraphicalDatePickerStyle())

                    DatePicker("종료 날짜", selection: $endDate, displayedComponents: .date)
                        .padding()
                        .datePickerStyle(GraphicalDatePickerStyle())

                    Button("생성") {
                        let startDateString = viewModel.stringFromDate(startDate)
                        let endDateString = viewModel.stringFromDate(endDate)
                        viewModel.generateSampleData(startDateString: startDateString, endDateString: endDateString)
                        viewModel.fetchStudySession()
                        isPresented = false
                    }
                    .padding()
                    Spacer()
                }
            }
            .navigationBarTitle("샘플 데이터 생성", displayMode: .inline)
            .navigationBarItems(trailing: Button("취소") {
                isPresented = false
            })
        }
    }
}

struct StudySessionRow: View {
    @StateObject var viewModel: CalendarViewModel = Container.shared.resolve(CalendarViewModel.self)
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
