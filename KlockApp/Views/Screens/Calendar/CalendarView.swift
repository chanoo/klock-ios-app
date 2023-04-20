//
//  CalendarView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/15.
//

import Foundation
import SwiftUI

struct CalendarView: View {
    @State private var spacing: CGFloat = 5
    @StateObject var viewModel = Container.shared.resolve(CalendarViewModel.self)
    let weeks = 14

    private var startDate: Date {
        let today = Date()
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: today) - calendar.firstWeekday
        let currentWeekStartDate = calendar.date(byAdding: .day, value: -dayOfWeek, to: today) ?? today
        return calendar.date(byAdding: .weekOfYear, value: -weeks + 1, to: currentWeekStartDate) ?? currentWeekStartDate
    }

    private var horizontalPadding: CGFloat {
        return 8 + spacing * 20
    }
    
    private var dayViewSize: CGFloat {
        return (UIScreen.main.bounds.width - horizontalPadding) / CGFloat(weeks)
    }
      
    var body: some View {
        VStack {
            if viewModel.isLoading {
                // 로딩 인디케이터를 표시
                ProgressView()
            } else {
                // 기존 캘린더 뷰를 표시
                if weeks > 15 {
                    ScrollView(.horizontal, showsIndicators: false) {
                        VStack {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                .overlay(
                                    calendarBody
                                        .padding(.leading, dayViewSize + spacing)
                                )
                                .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                        }
                        .padding(.all, 10)
                    }

                    VStack(alignment: .leading, spacing: spacing) {
                        DayView(size: dayViewSize, backgroundColor: .clear)
                        ForEach(0..<7) { day in
                            DayView(displayText: DateFormatter().shortWeekdaySymbols[day].prefix(1).uppercased(), size: dayViewSize, backgroundColor: .clear)
                        }
                        Spacer()
                    }

                } else {
                    calendarBody
                }

            }
        }
        .navigationBarTitle("공부 시간")        
    }

    private var calendarBody: some View {
        VStack {
            HStack(spacing: spacing) {
                DayView(size: dayViewSize, backgroundColor: .clear)

                ForEach(Array(0..<weeks), id: \.self) { week in
                    let calendar = Calendar.current
                    let currentDate = calendar.date(byAdding: .day, value: week * 7, to: startDate)!
                    monthText(forWeekStartingOn: currentDate)
                }
            }

            ForEach(0..<7) { day in
                HStack(spacing: spacing) {
                    DayView(displayText: DateFormatter().shortWeekdaySymbols[day].prefix(1).uppercased(), size: dayViewSize, backgroundColor: .clear)

                    ForEach(Array(0..<weeks), id: \.self) { week in
                        let calendar = Calendar.current
                        let currentDate = calendar.date(byAdding: .day, value: day + (week * 7), to: startDate)!
                        let dateString = viewModel.stringFromDate(currentDate)
                        
                        VStack(alignment: .center, spacing: 0) {
                            let studySessions = viewModel.studySessions[dateString] ?? []
                            let backgroundColor = color(for: studySessions, date: currentDate)
                            let randomDelay = Double.random(in: 0...2)
                            let maxBlinks = studySessions.isEmpty ? 0 : Int.random(in: 1...2)
                            DayView(size: dayViewSize, backgroundColor: backgroundColor, fadeInOutDuration: 0.5, randomDelay: randomDelay, maxBlinks: maxBlinks) {
                                // 여기에 버튼을 클릭했을 때의 액션을 추가하세요.
                                debugPrint(dateString, studySessions)
                            }
                        }
                    }

                }
            }
            
            Spacer()
        }
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
        let totalDuration = studySessions.reduce(0) { $0 + $1.sessionDuration }
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
            return Color.gray.opacity(0.3)
        case 1...leve1:
            return Color.green.opacity(0.2)
        case leve1...leve2:
            return Color.green.opacity(0.4)
        case leve2...leve3:
            return Color.green.opacity(0.6)
        case leve3...leve4:
            return Color.green.opacity(0.8)
        default:
            return Color.green
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
