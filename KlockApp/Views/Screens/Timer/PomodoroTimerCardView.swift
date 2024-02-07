//
//  PomodoroTimerCardView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/05/18.
//

import SwiftUI

struct PomodoroTimerCardView: View {
    
    @EnvironmentObject var pomodoroTimerViewModel: PomodoroTimerViewModel
    @EnvironmentObject var timeTimerViewModel: TimeTimerViewModel
    @EnvironmentObject var tabBarManager: TabBarManager
    @State private var isFlipped: Bool = false
    @ObservedObject var clockViewModel = ClockViewModel(
        currentTime: Date(),
        startTime: Date(),
        elapsedTime: 0,
        isStudying: false,
        isRunning: true
    )
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private func flipAnimation() {
        withAnimation(.spring()) {
            isFlipped.toggle()
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            frontView(geometry: geometry)
                .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0.0, y: 1.0, z: 0.0))
                .opacity(isFlipped ? 0 : 1)
            
            backView(geometry: geometry)
                .rotation3DEffect(.degrees(isFlipped ? 0 : 180), axis: (x: 0.0, y: 1.0, z: 0.0))
                .opacity(isFlipped ? 1 : 0)
        }
        .background(FancyColor.background.color)
        .cornerRadius(10)
        .shadow(color: Color(.systemGray).opacity(0.2), radius: 5, x: 0, y: 0)
    }
    
    private func frontView(geometry: GeometryProxy) -> some View {
        ZStack {
            Image("img_watch_background3")
                .aspectRatio(contentMode: .fill)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)

            Button(action: flipAnimation) {
                Image(systemName: "gearshape")
                    .frame(width: 20, height: 20)
            }
            .position(x: geometry.size.width - 25, y: 25)
            
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
                    title: "공부 시작",
                    action: {
                        withAnimation {
                            tabBarManager.isTabBarVisible = false
                            pomodoroTimerViewModel.isStudying = true
                            timeTimerViewModel.startStudySession()
                            timeTimerViewModel.pomodoroTimerViewModel = pomodoroTimerViewModel
                        }
                    },
                    style: .constant(.primary)
                )
            }
        }
        .background(FancyColor.background.color)
    }

    private func backView(geometry: GeometryProxy) -> some View {
        VStack {
            List {
                Section(header: Text("뽀모도로 설정")) {
                    VStack(alignment: .leading) {
                        Text("공부")
                            .font(.headline)
                            .foregroundColor(.gray)
                        TextField("어떤 공부를 할건가요?", text: $pomodoroTimerViewModel.model.name)
                    }

                    VStack(alignment: .leading) {
                        Text("공부 시간")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Stepper(value: $pomodoroTimerViewModel.model.focusTime, in: 5...60, step: 5) {
                            Text("\(pomodoroTimerViewModel.model.focusTime)분")
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("쉬는 시간")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Stepper(value: $pomodoroTimerViewModel.model.breakTime, in: 5...60, step: 5) {
                            Text("\(pomodoroTimerViewModel.model.breakTime)분")
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("반복 횟수")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Stepper(value: $pomodoroTimerViewModel.model.cycleCount, in: 1...10) {
                            Text("\(pomodoroTimerViewModel.model.cycleCount)회")
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        // Save settings
                        withAnimation(.spring()) {
                            timeTimerViewModel.update(type: TimerType.pomodoro.rawValue, model: pomodoroTimerViewModel.model)
                            isFlipped.toggle()
                        }
                    }) {
                        Text("저장")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                
                Section {
                    Button(action: {
                        withAnimation(.spring()) {
                            isFlipped.toggle()
                        }
                    }) {
                        Text("취소")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                
                Section {
                    Button(action: {
                        withAnimation(.spring()) {
                            flipAnimation()
                            timeTimerViewModel.delete(model: pomodoroTimerViewModel.model)
                        }
                    }) {
                        Text("삭제")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(FancyColor.secondary.color)
                    }
                }
            }
    //                .listStyle(GroupedListStyle())
            .clearListBackground()
        }
    }
}

//struct PomodoroTimerView_Previews: PreviewProvider {
//    static var previews: some View {
//        PomodoroTimerView()
//    }
//}
