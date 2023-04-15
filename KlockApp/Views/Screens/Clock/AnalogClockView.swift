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

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            
            if let imageName = viewModel.clockModel.clockBackgroundImageName {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: viewModel.clockModel.clockSize.width, height: viewModel.clockModel.clockSize.height)
            }

            Circle()
                .stroke(lineWidth: 1)
                .foregroundColor(.black)
                .frame(width: viewModel.clockModel.clockSize.width, height: viewModel.clockModel.clockSize.height)
                .overlay(
                    ZStack {
                        ClockHand(angle: .degrees(hourAngle), length: viewModel.clockModel.hourHandLength, thickness: viewModel.clockModel.hourHandThickness, color: .black, imageName: viewModel.clockModel.hourHandImageName, clockSize: viewModel.clockModel.clockSize)

                        ClockHand(angle: .degrees(minuteAngle), length: viewModel.clockModel.minuteHandLength, thickness: viewModel.clockModel.minuteHandThickness, color: .black, imageName: viewModel.clockModel.minuteHandImageName, clockSize: viewModel.clockModel.clockSize)

                        ClockHand(angle: .degrees(secondAngle), length: viewModel.clockModel.secondHandLength, thickness: viewModel.clockModel.secondHandThickness, color: .red, imageName: viewModel.clockModel.secondHandImageName, clockSize: viewModel.clockModel.clockSize)
                        
                        ZStack {
                            ForEach(viewModel.studySessions.indices) { index in
                                let studySession = viewModel.studySessions[index]
                                let elapsedTime = studySession.endTime.timeIntervalSince(studySession.startTime)
                                let isAfternoon = Calendar.current.component(.hour, from: studySession.startTime) >= 12
                                let lineWidth: CGFloat = isAfternoon ? 5 : 5
                                let circleRadius = isAfternoon ? (viewModel.clockModel.clockSize.width / 2) + 12: (viewModel.clockModel.clockSize.width / 2) + 5
                                let startAngle = angleForTime(date: studySession.startTime)
                                let endAngle = startAngle + elapsedTime / (12 * 3600) * 360

                                // 원래 코드에서는 Circle().trim(from: 0, to: trimTo)를 사용하였으나, 이제 시작 각도와 종료 각도를 사용하여 도넛 그래프를 그립니다.
                                Path { path in
                                    let startPoint = CGPoint(x: viewModel.clockModel.clockSize.width / 2 + circleRadius * cos(CGFloat(startAngle - 90) * .pi / 180), y: viewModel.clockModel.clockSize.height / 2 + circleRadius * sin(CGFloat(startAngle - 90) * .pi / 180))
                                    let endPoint = CGPoint(x: viewModel.clockModel.clockSize.width / 2 + circleRadius * cos(CGFloat(endAngle - 90) * .pi / 180), y: viewModel.clockModel.clockSize.height / 2 + circleRadius * sin(CGFloat(endAngle - 90) * .pi / 180))

                                    path.move(to: startPoint)
                                    path.addArc(center: CGPoint(x: viewModel.clockModel.clockSize.width / 2, y: viewModel.clockModel.clockSize.height / 2), radius: circleRadius, startAngle: .degrees(startAngle - 90), endAngle: .degrees(endAngle - 90), clockwise: false)
                                    path.addLine(to: endPoint)
                                }
                                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                                .foregroundColor(isAfternoon ? FancyColor.primary.color.opacity(0.9) : FancyColor.primary.color.opacity(0.7))
                                .frame(width: viewModel.clockModel.clockSize.width, height: viewModel.clockModel.clockSize.height) // 프레임 크기를 시계 크기와 동일하게 설정
                            }
                        }
                    }
                )
            
            // 도넛 그래프 추가
       
        }
        .onReceive(timer) { _ in
            currentTime = Date()
            let _ = viewModel.objectWillChange
        }
    }
    
    private func angleForTime(date: Date) -> Double {
        let hour = Calendar.current.component(.hour, from: date)
        let minute = Calendar.current.component(.minute, from: date)
        let second = Calendar.current.component(.second, from: date)
        let totalSeconds = Double(hour * 3600 + minute * 60 + second)
        return totalSeconds / 43200 * 360
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
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: thickness, height: length) // 바늘 길이를 1/10만큼 늘립니다.
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
