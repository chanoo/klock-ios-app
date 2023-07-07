//
//  FocusTimerView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/05/16.
//

import SwiftUI
import Foast

struct FocusTimerView: View {
    @EnvironmentObject var tabBarManager: TabBarManager
    @EnvironmentObject var focusTimerViewModel: FocusTimerViewModel
    @EnvironmentObject var timeTimerViewModel: TimeTimerViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var showChatBot = false
    @State var clockViewModel = ClockViewModel(
        currentTime: Date(),
        startTime: Date(),
//        currentTime: TimeUtils.dateFromString(dateString: "20230704114000", format: "yyyyMMddHHmmss")!,
//        startTime: TimeUtils.dateFromString(dateString: "20230704114000", format: "yyyyMMddHHmmss")!,
        elapsedTime: 0,
        studySessions: [],
        isStudying: true,
        isRunning: true
    )
    var body: some View {
        GeometryReader { geometry in
            frontView(geometry: geometry)
        }
    }
    
    private func frontView(geometry: GeometryProxy) -> some View {
        ZStack(alignment: .center) {
//            Image("img_watch_background3")
//                .aspectRatio(contentMode: .fill)
//                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
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
                        outlineInColor: FancyColor.timerOutline.color,
                        outlineOutColor: FancyColor.timerOutline.color
                    )
                )
                .padding([.top, .bottom], 50)

                Text(focusTimerViewModel.model.name)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(FancyColor.timerFocusText.color)
                
                Text(clockViewModel.elapsedTimeToString())
                    .font(.system(size: 40, weight: .bold))
                    .monospacedDigit()
                    .foregroundColor(FancyColor.timerFocusText.color)
                    .padding([.top], 4)

//                Text("(\(focusTimerViewModel.elapsedTimeToString()))")
//                    .font(.system(size: 16, weight: .heavy))
//                    .foregroundColor(FancyColor.gray2.color)
//                    .padding([.bottom], 50)

                FancyButton(
                    title: "잠깐 쉴래요",
                    action: {
                        Foast.show(message: "정지하려면 길게 누르세요.")
                    },
                    longPressAction: {
                        withAnimation {
                            tabBarManager.show()
                            focusTimerViewModel.stopStudy()
                            focusTimerViewModel.elapsedTime = clockViewModel.elapsedTime
                            timeTimerViewModel.stopAndSaveStudySession(
                                timerName: focusTimerViewModel.model.name,
                                timerType: .focus,
                                startTime: clockViewModel.startTime,
                                endTime: clockViewModel.currentTime
                            )
                            timeTimerViewModel.focusTimerViewModel = nil
                        }
                    },
                    icon: Image("ic_pause"),
                    isBlock: false,
                    style: .constant(.black)
                )
                .padding(.top, 40)
                .padding(.bottom, 60)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        showChatBot = true
                    } label: {
                        Image("ic_star_balloon")
                    }
                    .padding(.bottom, 60)
                    .padding(.trailing, 30)
                }
                .shadow(color: Color(.systemGray).opacity(0.2), radius: 5, x: 0, y: 0)
                .sheet(isPresented: $showChatBot) {
                    let viewModel = Container.shared.resolve(ChatBotViewModel.self)
                    NavigationView {
                        ChatBotListView()
                            .environmentObject(viewModel)
                    }
                }
            }
        }
        .background(FancyColor.timerFocusBackground.color)
        .onAppear {
            clockViewModel.startStudy()
            timeTimerViewModel.startStudySession()
            timeTimerViewModel.playVibration()
        }
    }
}

struct FocusTimerView_Previews: PreviewProvider {
    static var previews: some View {
        let model = FocusTimerModel(id: 1, userId: 1, seq: 1, type: "FOCUS", name: "집중시간 타이머")
        let focusTimerViewModel = FocusTimerViewModel(model: model)
        let TimeTimerViewModel = Container.shared.resolve(TimeTimerViewModel.self)
        let TabBarManager = Container.shared.resolve(TabBarManager.self)

        FocusTimerView()
            .environmentObject(focusTimerViewModel)
            .environmentObject(TimeTimerViewModel)
            .environmentObject(TabBarManager)
    }
}
