//
//  CalendarView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/15.
//

import Foundation
import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var actionSheetManager: ActionSheetManager
    @StateObject var viewModel = Container.shared.resolve(CalendarViewModel.self)
    @State private var spacing: CGFloat = 5
    @State private var isShowingSelectTimer = false
    @State private var actionSheetView: CustomActionSheetView? = nil
    @State private var isActionSheetPresented = false
    let weeks = 13

    private var startDate: Date {
        let today = Date()
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: today) - calendar.firstWeekday
        let currentWeekStartDate = calendar.date(byAdding: .day, value: -dayOfWeek, to: today) ?? today
        return calendar.date(byAdding: .weekOfYear, value: -weeks + 1, to: currentWeekStartDate) ?? currentWeekStartDate
    }

    private var horizontalPadding: CGFloat {
        return spacing * 20
    }
    
    private var dayViewSize: CGFloat {
        return (UIScreen.main.bounds.width - horizontalPadding) / CGFloat(weeks) - 2.5
    }
      
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                LoadingView()
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        VStack(spacing: 0) {
                            calendarBody
                            VStack(spacing: 0) {
                                Text(viewModel.selectedDate)
                                    .font(.system(size: 13))
                                    .padding(.bottom, 4)
                                Text(viewModel.totalStudyTime)
                                    .foregroundColor(FancyColor.text.color)
                                    .font(.system(size: 16, weight: .heavy))
                            }
                            .padding([.top, .bottom], 18)
                        }
                        .padding(8)
                        .background(FancyColor.calendarBackground.color)
                        .cornerRadius(10)
                        .shadow(color: Color(.systemGray).opacity(0.2), radius: 5, x: 0, y: 0)
                    }
                    .padding(8)
                    
//                    HStack {
//                        Text("6월 28일 수요일에는\n얼마나 공부했을까요?")
//                            .font(.system(size: 24, weight: .heavy))
//                        Spacer()
//                    }
//                    .padding(12)
//                    .padding([.leading, .trailing], 24)

                    if viewModel.studySessionsOfDay.count > 0 {
                        VStack(spacing: 0) {
                            LazyVStack(spacing: 0) {
                                ForEach(viewModel.studySessionsOfDay, id: \.self.id) { studySession in
                                    Group {
                                        HStack(spacing: 0) {
                                            Text(studySession.timerName)
                                                .foregroundColor(FancyColor.text.color)
                                                .font(.system(size: 16, weight: .heavy))
                                            Spacer()
                                            VStack(alignment: .trailing, spacing: 0) {
                                                Text("\(TimeUtils.elapsedTimeToString(elapsedTime: studySession.duration))")
                                                    .foregroundColor(FancyColor.text.color)
                                                    .font(.system(size: 16, weight: .heavy))
                                                Text("\(TimeUtils.formattedDateString(from: studySession.startTime, format: "hh시 mm분")) ~ \(studySession.endTime != nil ? TimeUtils.formattedDateString(from: studySession.endTime!, format: "hh시 mm분") : "진행 중")")
                                                    .foregroundColor(FancyColor.gray6.color)
                                                    .font(.system(size: 13, weight: .regular))
                                                    .padding(.top, 4)
                                            }
                                        }
                                        .background(FancyColor.clear.color)
                                        .padding(8)
                                        .contextMenu {
                                            Button(action: {
                                                viewModel.studySessionModel = studySession
                                                actionSheetManager.actionSheet = CustomActionSheetView(
                                                    title: studySession.timerName,
                                                    message: "\(TimeUtils.formattedDateString(from: studySession.startTime, format: "hh시 mm분")) ~ \(studySession.endTime != nil ? TimeUtils.formattedDateString(from: studySession.endTime!, format: "hh시 mm분") : "진행 중")",
                                                    content: AnyView(
                                                        FancyTextField(
                                                            placeholder: "공부 내용을 적어주세요",
                                                            text: $viewModel.studySessionModel.timerName,
                                                            firstResponder: $viewModel.becomeFirstResponder) {
                                                                print("done")
                                                            }
                                                    ),
                                                    actionButtons: [
                                                        ActionButton(title: "완료", action: {
                                                            viewModel.updateStudySession()
                                                            viewModel.studySessionsOfDay[viewModel.studySessionsOfDay.firstIndex(where: { $0.id == studySession.id })!] = viewModel.studySessionModel
                                                            withAnimation(.spring()) {
                                                                actionSheetManager.isPresented = false
                                                                viewModel.hideKeyboard()
                                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                                    actionSheetManager.actionSheet = nil
                                                                }
                                                            }
                                                        }),
                                                    ],
                                                    cancelButton: ActionButton(title: "취소", action: {
                                                        withAnimation(.spring()) {
                                                            actionSheetManager.isPresented = false
                                                            viewModel.hideKeyboard()
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                                actionSheetManager.actionSheet = nil
                                                            }
                                                        }
                                                    })
                                                )
                                                withAnimation(.spring()) {
                                                    actionSheetManager.isPresented = true
                                                    viewModel.becomeFirstResponder = true
                                                }
                                            }) {
                                                Label("수정", image: "ic_pencil_line2")
                                            }
                                        }
                                        Divider()
                                            .padding([.leading, .trailing], 8)
                                    }
                                }
                            }
                            .padding(8)
                            .background(FancyColor.calendarBackground.color)
                            .cornerRadius(10)
                            .shadow(color: Color(.systemGray).opacity(0.2), radius: 5, x: 0, y: 0)
                        }
                        .padding(8)
                    } else {
                        VStack {
                            Spacer()
                            Text("공부 기록이 없어요~")
                                .foregroundColor(FancyColor.gray6.color)
                                .font(.system(size: 17, weight: .heavy))
                            Spacer()
                        }
                        .frame(height: 200)
                    }
                }
            }
        }
        .navigationBarTitle("공부 기록", displayMode: .inline)
        
        // 수정 함수 action
        
    }

    private var calendarBody: some View {
        VStack(spacing: spacing) {
            HStack(spacing: spacing) {
                DayView(size: dayViewSize, backgroundColor: .clear)

                ForEach(Array(0..<weeks), id: \.self) { week in
                    let calendar = Calendar.current
                    let currentDate = calendar.date(byAdding: .day, value: week * 7, to: startDate)!
                    monthText(forWeekStartingOn: currentDate)
                        .foregroundColor(FancyColor.gray7.color)
                }
            }

            ForEach(0..<7) { day in
                HStack(spacing: spacing) {
                    DayView(displayText: DateFormatter().shortWeekdaySymbols[day].prefix(1).uppercased(), size: dayViewSize, backgroundColor: .clear)
                        .foregroundColor(FancyColor.gray7.color)

                    ForEach(Array(0..<weeks), id: \.self) { week in
                        let calendar = Calendar.current
                        let currentDate = calendar.date(byAdding: .day, value: day + (week * 7), to: startDate)!
                        let dateString = TimeUtils.formattedDateString(from: currentDate, format: "yyyy-MM-dd")

                        VStack(alignment: .center, spacing: 0) {
                            let studySessions = viewModel.studySessions[dateString] ?? []
                            let backgroundColor = color(for: studySessions, date: currentDate)
                            let randomDelay = Double.random(in: 0...2)
                            let maxBlinks = studySessions.isEmpty ? 0 : Int.random(in: 1...2)
                            DayView(size: dayViewSize, backgroundColor: backgroundColor, fadeInOutDuration: 0.5, randomDelay: randomDelay, maxBlinks: maxBlinks) {
                                // 여기에 버튼을 클릭했을 때의 액션을 추가하세요.
                                debugPrint(dateString, studySessions)
                                viewModel.setStudySessionsOfDay(studySessions)
                                viewModel.setSelectedDate(dateString)
                            }
                        }
                    }
                }
            }
        }
        .padding([.top, .leading, .trailing], 4)
        .padding([.bottom], 8)
    }

    private func monthText(forWeekStartingOn startDate: Date) -> some View {
        let calendar = Calendar.current

        let firstDayOfMonthFound = (0...6).contains { offset in
            let date = calendar.date(byAdding: .day, value: offset, to: startDate)!
            return calendar.component(.day, from: date) == 1
        }

        if firstDayOfMonthFound {
            let dateWithFirstDayOfMonth = (0...6).first { offset in
                let date = calendar.date(byAdding: .day, value: offset, to: startDate)!
                return calendar.component(.day, from: date) == 1
            }.flatMap { calendar.date(byAdding: .day, value: $0, to: startDate) }

            let month = dateWithFirstDayOfMonth.map { calendar.component(.month, from: $0) } ?? 0
            return DayView(displayText: String(month), size: dayViewSize, backgroundColor: .clear)
        } else {
            return DayView(size: dayViewSize, backgroundColor: .clear)
        }
    }

    private func dayNumber(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: date)
    }
    
    private func isFuture(date: Date) -> Bool {
        let now = Date()
        return date > now
    }

    private func color(for studySessions: [StudySessionModel], date: Date) -> Color {
        let totalDuration = studySessions.reduce(0) { $0 + $1.duration }
        let isFutureDate = Calendar.current.compare(date, to: Date(), toGranularity: .day) == .orderedDescending

        if isFutureDate {
            return Color.clear // 미래의 날짜에 원하는 색상을 설정하세요.
        }
        
        let hour = 60 * 60
        let leve1: Double = Double(hour * 1)
        let leve2: Double = Double(hour * 2)
        let leve3: Double = Double(hour * 3)
        let leve4: Double = Double(hour * 4)

        switch totalDuration {
        case 0:
            return FancyColor.calendarEmptyCell.color
        case 1...leve1:
            return FancyColor.primary.color.opacity(0.2)
        case leve1...leve2:
            return FancyColor.primary.color.opacity(0.4)
        case leve2...leve3:
            return FancyColor.primary.color.opacity(0.6)
        case leve3...leve4:
            return FancyColor.primary.color.opacity(0.8)
        default:
            return FancyColor.primary.color
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
