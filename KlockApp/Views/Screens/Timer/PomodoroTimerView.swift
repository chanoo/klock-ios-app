//
//  PomodoroTimerView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/21.
//

import SwiftUI
import Foast

struct PomodoroTimerView: View {

    @EnvironmentObject var pomodoroTimerViewModel: PomodoroTimerViewModel
    @EnvironmentObject var timeTimerViewModel: TimeTimerViewModel
    @EnvironmentObject var tabBarManager: TabBarManager
    @ObservedObject var clockViewModel = ClockViewModel(
        currentTime: Date(),
        startTime: Date(),
        elapsedTime: 0,
        isStudying: false,
        isRunning: true
    )
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geometry in
            frontView(geometry: geometry)
        }
        .background(FancyColor.background.color)
        .shadow(color: Color(.systemGray).opacity(0.2), radius: 5, x: 0, y: 0)
    }
    
    private func frontView(geometry: GeometryProxy) -> some View {
        ZStack {
            Image("img_watch_background3")
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                Text(pomodoroTimerViewModel.elapsedTimeToString())
                    .font(.largeTitle)
                    .padding()
                    .background(.white.opacity(0.5))
                    .foregroundColor(.gray.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                AnalogClockView(
                    timer: timer,
                    clockViewModel: clockViewModel,
                    analogClockModel: AnalogClockModel(
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
                .environmentObject(clockViewModel)
                .padding(.top, 20)
                .padding(.bottom, 20)
                
                FancyButton(
                    title: "잠시 멈춤",
                    action: {
                        Foast.show(message: "정지하려면 길게 누르세요.")
                    },
                    longPressAction: {
                        withAnimation {
                            tabBarManager.isTabBarVisible = true
                            pomodoroTimerViewModel.isStudying = false
                            timeTimerViewModel.pomodoroTimerViewModel = nil
                        }
                    },
                    style: .constant(.primary)
                )
            }
        }
        .background(FancyColor.background.color)
        .frame(width: geometry.size.width, height: geometry.size.height)
    }
}

struct PomodoroTimerView_Previews: PreviewProvider {
    static var previews: some View {
        let model = PomodoroTimerModel(id: 1, userId: 1, seq: 1, type: "POMODORO", name: "뽀모도로 타이머", focusTime: 25, breakTime: 5, cycleCount: 4)
        let viewModel = PomodoroTimerViewModel(model: model)
        PomodoroTimerView()
            .environmentObject(viewModel)
    }
}
