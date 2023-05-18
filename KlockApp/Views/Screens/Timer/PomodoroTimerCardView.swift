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
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                Text(timeTimerViewModel.elapsedTimeToString())
                    .font(.largeTitle)
                    .padding()
                    .background(.white.opacity(0.5))
                    .foregroundColor(.gray.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                AnalogClockView(
                    currentTime: Date(),
                    startTime: Date(),
                    elapsedTime: $pomodoroTimerViewModel.elapsedTime,
                    studySessions: .constant([]),
                    isStudying: $timeTimerViewModel.isStudying,
                    isRunning: true,
                    clockModel: ClockModel(
                        hourHandImageName: "img_watch_hand_hour",
                        minuteHandImageName: "img_watch_hand_min",
                        secondHandImageName: "img_watch_hand_sec",
                        clockBackgroundImageName: "img_watch_face1",
                        clockSize: CGSize(width: 300, height: 300),
                        hourHandColor: .black,
                        minuteHandColor: .black,
                        secondHandColor: .cyan,
                        outlineInColor: .white,
                        outlineOutColor: .white
                    ),
                    hour: 10,
                    minute: 20,
                    second: 35
                )
                .padding(.top, 20)
                .padding(.bottom, 20)

                FancyButton(
                    title: "공부 시작",
                    action: {
                        withAnimation {
                            timeTimerViewModel.startStudySession()
                            timeTimerViewModel.pomodoroTimerModel = pomodoroTimerViewModel.model
                            timeTimerViewModel.isStudying.toggle()
                            tabBarManager.isTabBarVisible.toggle()
                        }
                    },
                    backgroundColor: .white.opacity(0.4),
                    foregroundColor: .pink.opacity(0.5),
                    isBlock: false
                )
            }

            HStack {
                Spacer()
                Button(action: flipAnimation) {
                    Image(systemName: "gearshape")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .padding(.top, 16)
                .padding(.trailing, 16)
            }
            .position(x: geometry.size.width / 2, y: 16)
        }
        .background(FancyColor.background.color)
        .frame(width: geometry.size.width, height: geometry.size.height)
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
                        Stepper(value: $pomodoroTimerViewModel.model.restTime, in: 5...60, step: 5) {
                            Text("\(pomodoroTimerViewModel.model.restTime)분")
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
