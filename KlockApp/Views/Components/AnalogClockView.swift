//
//  AnalogClockView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/15.
//

import SwiftUI

struct AnalogClockView: View {
    var clockViewModel: ClockViewModel
    var analogClockModel: AnalogClockModel
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            Circle()
                .foregroundColor(.clear)
                .frame(
                    width: analogClockModel.clockSize.width,
                    height: analogClockModel.clockSize.height
                )
                .overlay(
                    ZStack {
                        if let imageName = analogClockModel.clockBackgroundImageName {
                            Image(imageName)
                                .resizable()
                                .foregroundColor(.white.opacity(0.4))
                                .frame(width: analogClockModel.clockSize.width,
                                       height: analogClockModel.clockSize.height)
                        }

                        ClockHand(
                            angle: .degrees(hourAngle),
                            color: analogClockModel.hourHandColor,
                            imageName: analogClockModel.hourHandImageName,
                            clockSize: analogClockModel.clockSize
                        )

                        ClockHand(
                            angle: .degrees(minuteAngle),
                            color: analogClockModel.minuteHandColor,
                            imageName: analogClockModel.minuteHandImageName,
                            clockSize: analogClockModel.clockSize
                        )

                        ClockHand(
                            angle: .degrees(secondAngle),
                            color: analogClockModel.secondHandColor,
                            imageName: analogClockModel.secondHandImageName,
                            clockSize: analogClockModel.clockSize
                        )

                        Circle()
                            .stroke(lineWidth: 4)
                            .foregroundColor(analogClockModel.outlineOutColor)
                            .frame(width: analogClockModel.clockSize.width - 21, height: analogClockModel.clockSize.height - 21)
                            .opacity(0.3)

                        Circle()
                            .stroke(lineWidth: 4)
                            .foregroundColor(analogClockModel.outlineOutColor)
                            .frame(width: analogClockModel.clockSize.width - 13, height: analogClockModel.clockSize.height - 13)
                            .opacity(0.1)

                        ForEach(clockViewModel.studySessions, id: \.id) { studySession in
                            ClockOutLine(
                                studySession: studySession,
                                clockSize: analogClockModel.clockSize,
                                startTime: studySession.startTime,
                                endTime: studySession.endTime,
                                outlineInColor: analogClockModel.outlineInColor,
                                outlineOutColor: analogClockModel.outlineOutColor
                            )
                        }
                    }
                )

        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            clockViewModel.currentTime = Date()
        }
        .onReceive(timer) { _ in
            if clockViewModel.isRunning {
                clockViewModel.currentTime = clockViewModel.currentTime.addingTimeInterval(1)
                if clockViewModel.isStudying {
                    clockViewModel.elapsedTime = clockViewModel.currentTime.timeIntervalSince(clockViewModel.startTime)
                }
            }
        }
        .onAppear {
            self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        }
        .onDisappear {
            self.timer.upstream.connect().cancel()
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
        let lineWidth: CGFloat = isAfternoon ? 4 : 4
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
        .frame(width: clockSize.width, height: clockSize.height)
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
                .resizable()
                .scaleEffect(0.9)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(color)
                .rotationEffect(angle, anchor: .center) // 회전 중심을 조정합니다.
                .position(x: clockSize.width / 2, y: clockSize.height / 2) // 바늘을 시계의 중앙에 위치시킵니다.
        }
    }
}

struct AnalogClockView_Previews: PreviewProvider {
    static var previews: some View {
        @ObservedObject var clockViewModel = ClockViewModel(
            currentTime: Date(),
            startTime: Date(),
            elapsedTime: 0,
            studySessions: [],
            isStudying: false,
            isRunning: true
        )
        AnalogClockView(
            clockViewModel: clockViewModel,
            analogClockModel: AnalogClockModel(
                hourHandImageName: "img_watch_hand_hour",
                minuteHandImageName: "img_watch_hand_min",
                secondHandImageName: "img_watch_hand_sec",
                clockBackgroundImageName: "img_watch_face1",
                clockSize: CGSize(width: 260, height: 260),
                hourHandColor: FancyColor.white.color,
                minuteHandColor: FancyColor.white.color,
                secondHandColor: FancyColor.primary.color,
                outlineInColor: FancyColor.timerOutline.color.opacity(0.8),
                outlineOutColor: FancyColor.timerOutline.color.opacity(0.5)
            )
        )
        .environmentObject(clockViewModel)
        .background(FancyColor.background.color)
    }
}
