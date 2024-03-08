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
    @ObservedObject var timeTimerViewModel: TimeTimerViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var chatBotViewModel: ChatBotViewModel
    @State private var showChatBot = false
    @State var clockViewModel = ClockViewModel(
        currentTime: Date(),
        startTime: Date(),
        elapsedTime: 0,
        isStudying: true,
        isRunning: true
    )
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geometry in
            frontView(geometry: geometry)
        }
    }
    
    private func updateCurrentTime(_ time: Date) {
        if focusTimerViewModel.isRunning {
            focusTimerViewModel.currentTime = focusTimerViewModel.currentTime.addingTimeInterval(1)
            if focusTimerViewModel.isStudying {
                focusTimerViewModel.elapsedTime = focusTimerViewModel.currentTime.timeIntervalSince(focusTimerViewModel.startTime)
            }
        }
    }
    
    private func frontView(geometry: GeometryProxy) -> some View {
        ZStack(alignment: .center) {
            chatBotButton(with: geometry)
            
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
//                    .padding([.bottom], 50)

                FancyButton(
                    title: "잠깐 쉴래요",
                    action: {
                        Foast.show(message: "정지하려면 길게 누르세요.")
                    },
                    longPressAction: {
                        stopAndSaveStudySession()
                    },
                    icon: Image("ic_pause"),
                    isBlock: false,
                    style: .constant(.black)
                )
                .padding(.top, Constants.topMediumPadding)
                .padding(.bottom, Constants.bottomPadding)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .background(FancyColor.timerFocusBackground.color)
        .onReceive(timer, perform: updateCurrentTime)
        .onAppear(perform: onAppearActions)
    }
    
    private func chatBotButton(with geometry: GeometryProxy) -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    showChatBot = true
                } label: {
                    Image("ic_star_balloon")
                }
                .padding(.bottom, Constants.chatbotBottomPadding)
                .padding(.trailing, Constants.chatbotTrailingPadding)
            }
            .padding(.bottom, 19)
            .shadow(color: Color(.systemGray).opacity(0.2), radius: 5, x: 0, y: 0)
            .sheet(isPresented: $showChatBot) {
                NavigationView {
                    ChatBotListView()
                }
            }
        }
    }
    
    private func onAppearActions() {
        clockViewModel.startStudy()
        focusTimerViewModel.startStudy()
        timeTimerViewModel.startStudySession(timerName: focusTimerViewModel.model.name)
        timeTimerViewModel.playVibration()
    }
    
    private func stopAndSaveStudySession() {
        withAnimation {
            tabBarManager.show()
            clockViewModel.stopStudy()
            focusTimerViewModel.stopStudy()
            focusTimerViewModel.elapsedTime = focusTimerViewModel.elapsedTime
            timeTimerViewModel.stopAndSaveStudySession(
                timerName: focusTimerViewModel.model.name,
                timerType: .focus,
                startTime: focusTimerViewModel.startTime,
                endTime: focusTimerViewModel.currentTime
            )
            let appUsageController = AppUsageController.shared
            appUsageController.stopMonitoring()
            timeTimerViewModel.focusTimerViewModel = nil
        }
    }
}

private struct Constants {
    static let topPadding: CGFloat = 80
    static let topSmallPadding: CGFloat = 2
    static let topMediumPadding: CGFloat = 40
    static let mediumPadding: CGFloat = 40
    static let bottomPadding: CGFloat = 80
    static let bottomLargePadding: CGFloat = 160
    static let chatbotBottomPadding: CGFloat = 60
    static let chatbotTrailingPadding: CGFloat = 30
}

struct FocusTimerView_Previews: PreviewProvider {
    static var previews: some View {
        let model = FocusTimerModel(id: 1, userId: 1, seq: 1, type: TimerType.focus.rawValue, name: "집중시간 타이머")
        let focusTimerViewModel = FocusTimerViewModel(model: model)
        let timeTimerViewModel = Container.shared.resolve(TimeTimerViewModel.self)
        let tabBarManager = Container.shared.resolve(TabBarManager.self)

        FocusTimerView(timeTimerViewModel: timeTimerViewModel)
            .environmentObject(focusTimerViewModel)
            .environmentObject(tabBarManager)
    }
}
