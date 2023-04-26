//
//  AnalogClockView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/15.
//

import SwiftUI

struct AnalogClockView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var currentTime: Date
    @State var startTime: Date
    @Binding var elapsedTime: TimeInterval
    @Binding var studySessions: [StudySessionModel]
    @Binding var isStudying: Bool
    @State var isRunning: Bool
    var clockModel: ClockModel
    var hour: Int?
    var minute: Int?
    var second: Int?

    var body: some View {
        ZStack {
            Image("img_watch_background4")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)

            VStack {

                Spacer()

                Text(elapsedTimeToString())
                    .font(.largeTitle)
                    .padding()
                    .background(.white.opacity(0.5))
                    .foregroundColor(.pink)
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                Spacer(minLength: 30)

                ZStack {

                    Circle()
                        .foregroundColor(colorScheme == .dark ? .pink.opacity(0.2) : .white.opacity(0.5))
                        .frame(
                            width: clockModel.clockSize.width,
                            height: clockModel.clockSize.height
                        )
                        .overlay(
                            ZStack {
                                if let imageName = clockModel.clockBackgroundImageName {
                                    Image(imageName)
                                        .foregroundColor(.pink.opacity(0.4))
                                        .frame(width: clockModel.clockSize.width,
                                               height: clockModel.clockSize.height)
                                }

                                ClockHand(
                                    angle: .degrees(hourAngle),
                                    color: .black,
                                    imageName: clockModel.hourHandImageName,
                                    clockSize: clockModel.clockSize
                                )

                                ClockHand(
                                    angle: .degrees(minuteAngle),
                                    color: .black,
                                    imageName: clockModel.minuteHandImageName,
                                    clockSize: clockModel.clockSize
                                )

                                ClockHand(
                                    angle: .degrees(secondAngle),
                                    color: .pink,
                                    imageName: clockModel.secondHandImageName,
                                    clockSize: clockModel.clockSize
                                )

                                Circle()
                                    .stroke(lineWidth: 10)
                                    .foregroundColor(.pink)
                                    .frame(width: clockModel.clockSize.width - 10, height: clockModel.clockSize.height - 10)
                                    .opacity(0.1)

                                Circle()
                                    .stroke(lineWidth: 10)
                                    .foregroundColor(.pink)
                                    .frame(width: clockModel.clockSize.width - 30, height: clockModel.clockSize.height - 30)
                                    .opacity(0.3)

                                ForEach(studySessions, id: \.id) { studySession in
                                    ClockOutLine(
                                        studySession: studySession,
                                        clockSize: clockModel.clockSize,
                                        startTime: studySession.startTime,
                                        endTime: studySession.endTime
                                    )
                                }
                            }
                        )
                }

                Spacer(minLength: 30)

                FancyButton(
                    title: isStudying ? "잠시 멈춤" : "공부 시작",
                    action: {
                        isRunning = true
                        isStudying.toggle()
                        startTime = Date()
                    },
                    backgroundColor: .pink.opacity(0.8),
                    foregroundColor: .white,
                    isBlock: false
                )

                Spacer()
            }
        }
        .onReceive(timer) { _ in
            if isRunning {
                currentTime = currentTime.addingTimeInterval(1)
                if isStudying {
                    elapsedTime = currentTime.timeIntervalSince(startTime)
                } else {
                    elapsedTime = 0
                }
            }
        }
    }

    private var hourAngle: Double {
        let hour = Calendar.current.component(.hour, from: currentTime)
        let minute = Calendar.current.component(.minute, from: currentTime)
        return (Double(hour % 12) + Double(minute) / 60) / 12 * 360
    }

    private var minuteAngle: Double {
        let minute = Calendar.current.component(.minute, from: currentTime)
        let second = Calendar.current.component(.second, from: currentTime)
        return (Double(minute) + Double(second) / 60) / 60 * 360
    }

    private var secondAngle: Double {
        let second = Calendar.current.component(.second, from: currentTime)
        return Double(second) / 60 * 360
    }
    
    private func elapsedTimeToString() -> String {
        // elapsedTime를 문자열로 변환하는 코드를 여기에 구현하세요.
        return TimeUtils.elapsedTimeToString(elapsedTime: elapsedTime ?? 0)
    }
}

struct ClockOutLine: View {
    let studySession: StudySessionModel
    let clockSize: CGSize
    let startTime: Date
    let endTime: Date

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
        .foregroundColor(isAfternoon ? .pink.opacity(0.5) : .pink.opacity(0.7))
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
            currentTime: Date(),
            startTime: Date(),
            elapsedTime: .constant(2),
            studySessions: .constant([]),
            isStudying: .constant(false),
            isRunning: true,
            clockModel:
                ClockModel(
                    hourHandImageName: "img_watch_hand_hour",
                    minuteHandImageName: "img_watch_hand_min",
                    secondHandImageName: "img_watch_hand_sec",
                    clockBackgroundImageName: "img_watch_face1",
                    clockSize: CGSize(width: 300, height: 300)
                )
        )
        .previewLayout(.sizeThatFits)
    }
}
