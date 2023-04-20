//
//  AnalogClockView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/15.
//

import SwiftUI

struct AnalogClockView: View {
    @ObservedObject private var viewModel: ClockViewModel = Container.shared.resolve(ClockViewModel.self)
    @State private var currentTime = Date()
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {

            Image("img_watch_background4")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)

            VStack {
                
                Spacer()

                Text(viewModel.elapsedTimeToString())
                    .font(.largeTitle)
                    .padding()
                    .background(.white.opacity(0.5))
                    .foregroundColor(.pink)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Spacer(minLength: 30)

                ZStack {
                    
                    Circle()
                        .foregroundColor(colorScheme == .dark ? .pink.opacity(0.2) : .white.opacity(0.5))
                        .frame(width: viewModel.clockModel.clockSize.width,
                               height: viewModel.clockModel.clockSize.height)
                        .overlay(
                            ZStack {
                                if let imageName = viewModel.clockModel.clockBackgroundImageName {
                                    Image(imageName)
                                        .foregroundColor(.pink.opacity(0.4))
                                        .frame(width: viewModel.clockModel.clockSize.width,
                                               height: viewModel.clockModel.clockSize.height)
                                }
                                
                                ClockHand(angle: .degrees(hourAngle), length: viewModel.clockModel.hourHandLength, thickness: viewModel.clockModel.hourHandThickness, color: .black, imageName: viewModel.clockModel.hourHandImageName, clockSize: viewModel.clockModel.clockSize)

                                ClockHand(angle: .degrees(minuteAngle), length: viewModel.clockModel.minuteHandLength, thickness: viewModel.clockModel.minuteHandThickness, color: .black, imageName: viewModel.clockModel.minuteHandImageName, clockSize: viewModel.clockModel.clockSize)

                                ClockHand(angle: .degrees(secondAngle), length: viewModel.clockModel.secondHandLength, thickness: viewModel.clockModel.secondHandThickness, color: .red, imageName: viewModel.clockModel.secondHandImageName, clockSize: viewModel.clockModel.clockSize)
                                
                                Circle()
                                    .stroke(lineWidth: 10)
                                    .foregroundColor(.pink)
                                    .frame(width: viewModel.clockModel.clockSize.width - 10, height: viewModel.clockModel.clockSize.height - 10)
                                    .opacity(0.1)
                                
                                Circle()
                                    .stroke(lineWidth: 10)
                                    .foregroundColor(.pink)
                                    .frame(width: viewModel.clockModel.clockSize.width - 30, height: viewModel.clockModel.clockSize.height - 30)
                                    .opacity(0.3)
                                
                                ZStack {
                                    ClockOutLine(studySession: viewModel.currentStudySession)
                                    ForEach(viewModel.studySessions.indices) { index in
                                        let studySession = viewModel.studySessions[index]
                                        ClockOutLine(studySession: studySession)
                                    }
                                    .environment(\.layoutDirection, .rightToLeft) // 경고를 숨기기 위한 코드
                                }
                            }
                        )
                }

                Spacer(minLength: 30)

                FancyButton(title: "잠시 멈춤", action: {
                    viewModel.stopAndSaveStudySession()
                    presentationMode.wrappedValue.dismiss()
                }, backgroundColor: .pink.opacity(0.8), foregroundColor: .white, isBlock: false)
                
                Spacer()

            }
        }
        .onReceive(timer) { _ in
            viewModel.elapsedTime += 1
            currentTime = Date()
            viewModel.updateTime()
            let _ = viewModel.objectWillChange
        }
        .onAppear {
            viewModel.loadStudyTime()
            viewModel.updateTime()
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
}

struct ClockOutLine: View {
    @ObservedObject private var viewModel: ClockViewModel = Container.shared.resolve(ClockViewModel.self)
    let studySession: StudySessionModel

    var body: some View {
        let elapsedTime = studySession.endTime.timeIntervalSince(studySession.startTime)
        let morningEndTime = Calendar.current.date(bySettingHour: 11, minute: 59, second: 59, of: studySession.startTime)!
        
        if studySession.startTime <= morningEndTime && studySession.endTime > morningEndTime {
            // Session spans across morning and afternoon
            ClockOutLineSegment(studySession: studySession, startTime: studySession.startTime, endTime: morningEndTime)
            ClockOutLineSegment(studySession: studySession, startTime: morningEndTime.addingTimeInterval(1), endTime: studySession.endTime)
        } else {
            // Session is either in the morning or afternoon
            ClockOutLineSegment(studySession: studySession, startTime: studySession.startTime, endTime: studySession.endTime)
        }
    }
}

struct ClockOutLineSegment: View {
    @ObservedObject private var viewModel: ClockViewModel = Container.shared.resolve(ClockViewModel.self)
    let studySession: StudySessionModel
    let startTime: Date
    let endTime: Date

    var body: some View {
        let elapsedTime = endTime.timeIntervalSince(startTime)
        let isAfternoon = Calendar.current.component(.hour, from: startTime) >= 12
        let lineWidth: CGFloat = isAfternoon ? 10 : 10
        let circleRadius = isAfternoon ? (viewModel.clockModel.clockSize.width / 2) - 5: (viewModel.clockModel.clockSize.width / 2) - 15
        let startAngle = viewModel.angleForTime(date: startTime)
        let endAngle = startAngle + elapsedTime / (12 * 3600) * 360

        Path { path in
            let startPoint = CGPoint(x: viewModel.clockModel.clockSize.width / 2 + circleRadius * cos(CGFloat(startAngle - 90) * .pi / 180), y: viewModel.clockModel.clockSize.height / 2 + circleRadius * sin(CGFloat(startAngle - 90) * .pi / 180))
            let endPoint = CGPoint(x: viewModel.clockModel.clockSize.width / 2 + circleRadius * cos(CGFloat(endAngle - 90) * .pi / 180), y: viewModel.clockModel.clockSize.height / 2 + circleRadius * sin(CGFloat(endAngle - 90) * .pi / 180))

            path.move(to: startPoint)
            path.addArc(center: CGPoint(x: viewModel.clockModel.clockSize.width / 2, y: viewModel.clockModel.clockSize.height / 2), radius: circleRadius, startAngle: .degrees(startAngle - 90), endAngle: .degrees(endAngle - 90), clockwise: false)
            path.addLine(to: endPoint)
        }
        .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .butt, lineJoin: .round))
        .foregroundColor(isAfternoon ? .pink.opacity(0.5) : .pink.opacity(0.7))
        .frame(width: viewModel.clockModel.clockSize.width, height: viewModel.clockModel.clockSize.height) // Set the frame size to be the same as the clock size
    }
}

// ClockHand 구조체는 시계의 바늘을 표시하는 View 입니다.
struct ClockHand: View {
    // 각도, 바늘의 길이, 두께, 색상, 이미지 이름 및 시계 크기를 저장하는 변수들입니다.
    let angle: Angle
    let length: CGFloat
    let thickness: CGFloat
    let color: Color
    let imageName: String?
    let clockSize: CGSize

    // ClockHand View의 본문입니다.
    var body: some View {
        // imageName이 있으면 이미지를 사용하여 바늘을 표시합니다.
        if let imageName = imageName {
            GeometryReader { geometry in
                Image(imageName)
                    .foregroundColor(.pink)
                    .rotationEffect(angle, anchor: .center) // 회전 중심을 조정합니다.
                    .position(x: clockSize.width / 2, y: clockSize.height / 2) // 바늘을 시계의 중앙에 위치시킵니다.
            }
        } else {
            // imageName이 없으면 RoundedRectangle을 사용하여 바늘을 표시합니다.
            GeometryReader { geometry in
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: thickness, height: length) // 바늘 길이를 1/10만큼 늘립니다.
                    .foregroundColor(color)
                    .rotationEffect(angle, anchor: .center) // 회전 중심을 조정합니다.
                    .position(x: clockSize.width / 2, y: clockSize.height / 2) // 바늘을 시계의 중앙에 위치시킵니다.
            }
        }

    }
}

struct AnalogClockView_Previews: PreviewProvider {
    static var previews: some View {
        AnalogClockView()
            .frame(width: 300, height: 300)
            .previewLayout(.sizeThatFits)
    }
}

