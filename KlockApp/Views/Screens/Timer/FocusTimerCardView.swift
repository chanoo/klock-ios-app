//
//  FocusTimerCardView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/05/16.
//

import SwiftUI

struct FocusTimerCardView: View {
    @EnvironmentObject var tabBarManager: TabBarManager
    @StateObject var timerModel: TimerModel
    @StateObject var focusTimerViewModel: FocusTimerViewModel
    @StateObject var timeTimerViewModel: TimeTimerViewModel
    @StateObject var clockViewModel = ClockViewModel(
        currentTime: Date(),
        startTime: Date(),
        elapsedTime: 0,
        isStudying: false,
        isRunning: true
    )
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private func flipAnimation() {
        withAnimation(.spring()) {
            timerModel.isFlipped?.toggle()
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            frontView(geometry: geometry)
                .rotation3DEffect(.degrees(timerModel.isFlipped ?? false ? 180 : 0), axis: (x: 0.0, y: 1.0, z: 0.0))
                .opacity(timerModel.isFlipped ?? false ? 0 : 1)
            
            backView(geometry: geometry)
                .rotation3DEffect(.degrees(timerModel.isFlipped ?? false ? 0 : 180), axis: (x: 0.0, y: 1.0, z: 0.0))
                .opacity(timerModel.isFlipped ?? false ? 1 : 0)
        }
        .cornerRadius(10)
        .shadow(color: Color(.systemGray).opacity(0.2), radius: 5, x: 0, y: 0)
    }
    
    private func frontView(geometry: GeometryProxy) -> some View {
        ZStack(alignment: .center) {
//            Image("img_watch_background3")
//                .aspectRatio(contentMode: .fill)
//                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)

            Button(action: {
                flipAnimation()
                tabBarManager.hide()
            }) {
                Image("ic_3dots")
                    .foregroundColor(FancyColor.gray3.color)
            }
            .position(x: geometry.size.width - 30, y: 30)
            
            VStack(spacing: 0) {
                Spacer()
                AnalogClockView(
                    timer: timer,
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
                        outlineInColor: FancyColor.timerOutline.color,
                        outlineOutColor: FancyColor.timerOutline.color
                    )
                )
                Spacer()

                Text(focusTimerViewModel.model.name)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(FancyColor.timerFocusText.color)
                
                Text(focusTimerViewModel.elapsedTimeToString())
                    .font(.system(size: 40, weight: .bold))
                    .monospacedDigit()
                    .foregroundColor(FancyColor.timerFocusText.color)
                    .padding([.top], 4)

//                Text("(\(focusTimerViewModel.elapsedTimeToString()))")
//                    .font(.system(size: 16, weight: .heavy))
//                    .foregroundColor(FancyColor.gray2.color)
                
                FancyButton(
                    title: "공부 시작",
                    action: {
                        withAnimation {
                            tabBarManager.hide()
                            timeTimerViewModel.focusTimerViewModel = focusTimerViewModel
                            let appUsageController = AppUsageController.shared
                            appUsageController.initiateMonitoring()
                        }
                    },
                    icon: Image("ic_play"),
                    isBlock: false,
                    style: .constant(.black)
                )
                .padding(.top, 30)
                .padding(.bottom, 60)
            }
        }
        .background(FancyColor.timerFocusBackground.color)
    }

    private func backView(geometry: GeometryProxy) -> some View {
        VStack {
            List {
                Section(header: Text("집중시간 타이머 설정")) {
                    VStack(alignment: .leading) {
                        Text("과목명")
                            .font(.headline)
                            .foregroundColor(.gray)
                        TextField("어떤 공부를 할건가요?", text: $focusTimerViewModel.model.name)
                    }
                }

                Section {
                    Button(action: {
                        timeTimerViewModel.update(type: TimerType.focus.rawValue, model: focusTimerViewModel.model)
                        flipAnimation()
                        tabBarManager.show()
                    }) {
                        Text("저장")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }

                Section {
                    Button(action: {
                        flipAnimation()
                        tabBarManager.show()
                    }) {
                        Text("취소")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }

                Section {
                    Button(action: {
                        flipAnimation()
                        tabBarManager.show()
                        timeTimerViewModel.delete(model: focusTimerViewModel.model)
                    }) {
                        Text("삭제")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(FancyColor.secondary.color)
                    }
                }
            }
            .clearListBackground()
        }
        .background(FancyColor.chatBotBackground.color)
    }
}

struct FocusTimerCardView_Previews: PreviewProvider {
    static var previews: some View {
        let timerModel = TimerModel(id: 1, userId: 1, seq: 1, type: "AUTO", name: "국어")
        let model = FocusTimerModel(id: 1, userId: 1, seq: 1, type: TimerType.focus.rawValue, name: "집중시간 타이머")
        let viewModel = FocusTimerViewModel(model: model)
        let timeTimerViewModel = Container.shared.resolve(TimeTimerViewModel.self)
        FocusTimerCardView(timerModel: timerModel, focusTimerViewModel: viewModel, timeTimerViewModel: timeTimerViewModel)
    }
}
