//
//  AnalogClockView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/15.
//

import SwiftUI

struct AnalogClockView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var tabBarManager: TabBarManager
    @StateObject var clockViewModel: ClockViewModel
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var clockModel: ClockModel

    var body: some View {
        VStack {
            Circle()
                .foregroundColor(.clear)
                .frame(
                    width: clockModel.clockSize.width,
                    height: clockModel.clockSize.height
                )
                .overlay(
                    ZStack {
                        if let imageName = clockModel.clockBackgroundImageName {
                            Image(imageName)
                                .foregroundColor(.white.opacity(0.4))
                                .frame(width: clockModel.clockSize.width,
                                       height: clockModel.clockSize.height)
                        }

                        ClockHand(
                            angle: .degrees(hourAngle),
                            color: clockModel.hourHandColor,
                            imageName: clockModel.hourHandImageName,
                            clockSize: clockModel.clockSize
                        )

                        ClockHand(
                            angle: .degrees(minuteAngle),
                            color: clockModel.minuteHandColor,
                            imageName: clockModel.minuteHandImageName,
                            clockSize: clockModel.clockSize
                        )

                        ClockHand(
                            angle: .degrees(secondAngle),
                            color: clockModel.secondHandColor,
                            imageName: clockModel.secondHandImageName,
                            clockSize: clockModel.clockSize
                        )

                        Circle()
                            .stroke(lineWidth: 10)
                            .foregroundColor(clockModel.outlineOutColor)
                            .frame(width: clockModel.clockSize.width - 10, height: clockModel.clockSize.height - 10)
                            .opacity(0.1)

                        Circle()
                            .stroke(lineWidth: 10)
                            .foregroundColor(clockModel.outlineOutColor)
                            .frame(width: clockModel.clockSize.width - 30, height: clockModel.clockSize.height - 30)
                            .opacity(0.3)

                        ForEach(clockViewModel.studySessions, id: \.id) { studySession in
                            ClockOutLine(
                                studySession: studySession,
                                clockSize: clockModel.clockSize,
                                startTime: studySession.startTime,
                                endTime: studySession.endTime,
                                outlineInColor: clockModel.outlineInColor,
                                outlineOutColor: clockModel.outlineOutColor
                            )
                        }
                    }
                )

        }
        .onReceive(timer) { _ in
            if clockViewModel.isRunning {
                clockViewModel.currentTime = clockViewModel.currentTime.addingTimeInterval(1)
                if clockViewModel.isStudying {
                    clockViewModel.elapsedTime = clockViewModel.currentTime.timeIntervalSince(clockViewModel.startTime)
                } else {
                    clockViewModel.elapsedTime = 0
                }
            }
        }
    }

    private var hourAngle: Double {
        let hour = Calendar.current.component(.hour, from: clockViewModel.currentTime)
        let minute = Calendar.current.component(.minute, from: clockViewModel.currentTime)
        return (Double(hour % 12) + Double(minute) / 60) / 12 * 360
    }

    private var minuteAngle: Double {
        let minute = Calendar.current.component(.minute, from: clockViewModel.currentTime)
        let second = Calendar.current.component(.second, from: clockViewModel.currentTime)
        return (Double(minute) + Double(second) / 60) / 60 * 360
    }

    private var secondAngle: Double {
        let second = Calendar.current.component(.second, from: clockViewModel.currentTime)
        return Double(second) / 60 * 360
    }
}

struct ClockOutLine: View {
    let studySession: StudySessionModel
    let clockSize: CGSize
    let startTime: Date
    let endTime: Date
    let outlineInColor: Color
    let outlineOutColor: Color

    var body: some View {
        let elapsedTime = endTime.timeIntervalSince(startTime)
        let isAfternoon = Calendar.current.component(.hour, from: startTime) >= 12
        let lineWidth: CGFloat = isAfternoon ? 10 : 10
        let circleRadius = isAfternoon ? (clockSize.width / 2) - 5: (clockSize.width / 2) - 15
        let startAngle = TimeUtils.angleForTime(date: startTime)
        let endAngle = startAngle + elapsedTime / (12 * 3600) * 360

        Path { path in
            let startPoint = CGPoint(x: clockSize.width / 2 + circleRadius * cos(CGFloat(startAngle - 90) * .pi / 180), y: clockSize.height / 2 + circleRadius * sin(CGFloat(startAngle - 90) * .pi / 180))
            let endPoint = CGPoint(x: clockSize.width / 2 + circleRadius * cos(CGFloat(endAngle - 90) * .pi / 180), y: clockSize.height / 2 + circleRadius * sin(CGFloat(endAngle - 90) * .pi / 180))

            path.move(to: startPoint)
            path.addArc(center: CGPoint(x: clockSize.width / 2, y: clockSize.height / 2), radius: circleRadius, startAngle: .degrees(startAngle - 90), endAngle: .degrees(endAngle - 90), clockwise: false)
            path.addLine(to: endPoint)
        }
        .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .butt, lineJoin: .round))
        .foregroundColor(isAfternoon ? outlineOutColor : outlineInColor)
        .frame(width: clockSize.width, height: clockSize.height) // Set the frame size to be the same as the clock size
    }
}

// ClockHand 구조체는 시계의 바늘을 표시하는 View 입니다.
struct ClockHand: View {
    let angle: Angle
    let color: Color
    let imageName: String
    let clockSize: CGSize

    // ClockHand View의 본문입니다.
    var body: some View {
        // imageName이 있으면 이미지를 사용하여 바늘을 표시합니다.
        GeometryReader { geometry in
            Image(imageName)
                .foregroundColor(color)
                .rotationEffect(angle, anchor: .center) // 회전 중심을 조정합니다.
                .position(x: clockSize.width / 2, y: clockSize.height / 2) // 바늘을 시계의 중앙에 위치시킵니다.
        }
    }
}

struct AnalogClockView_Previews: PreviewProvider {
    static var previews: some View {
        AnalogClockView(
            clockViewModel: ClockViewModel(
                currentTime: Date(),
                startTime: Date(),
                elapsedTime: 2,
                studySessions: [],
                isStudying: false,
                isRunning: true
            ),
            clockModel: ClockModel(
                hourHandImageName: "img_watch_hand_hour",
                minuteHandImageName: "img_watch_hand_min",
                secondHandImageName: "img_watch_hand_sec",
                clockBackgroundImageName: "img_watch_face1",
                clockSize: CGSize(width: 300, height: 300),
                hourHandColor: .black,
                minuteHandColor: .black,
                secondHandColor: .pink,
                outlineInColor: .white.opacity(0.8),
                outlineOutColor: .white.opacity(0.5)
            )
        )
        .background(FancyColor.background.color)
    }
}
