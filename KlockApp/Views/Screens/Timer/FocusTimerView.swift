//
//  FocusTimerView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/05/16.
//

import SwiftUI
import Foast

struct FocusTimerView: View {
    @EnvironmentObject var focusTimerViewModel: FocusTimerViewModel
    @EnvironmentObject var timeTimerViewModel: TimeTimerViewModel
    @EnvironmentObject var tabBarManager: TabBarManager
    @State private var showChatBot = false

    var body: some View {
        GeometryReader { geometry in
            frontView(geometry: geometry)
        }
    }
    
    private func frontView(geometry: GeometryProxy) -> some View {
        ZStack {
//            Image("img_watch_background3")
//                .aspectRatio(contentMode: .fill)
//                .edgesIgnoringSafeArea(.all)
            
            VStack {

                AnalogClockView(
                    clockViewModel: ClockViewModel(
                        currentTime: Date(),
                        startTime: Date(),
                        elapsedTime: 2,
                        studySessions: [],
                        isStudying: false,
                        isRunning: true
                    ),
                    clockModel: ClockModel(
                        hourHandImageName: "img_watch_hand_hour",
                        minuteHandImageName: "img_watch_hand_min",
                        secondHandImageName: "img_watch_hand_sec",
                        clockBackgroundImageName: "img_watch_face1",
                        clockSize: CGSize(width: 200, height: 200),
                        hourHandColor: .white,
                        minuteHandColor: .white,
                        secondHandColor: .mint,
                        outlineInColor: .white.opacity(0.8),
                        outlineOutColor: .white.opacity(0.5)
                    )
                )
                .padding(.top, 20)
                .padding(.bottom, 50)
                
                Text(focusTimerViewModel.model.name)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.black)
                
                Text(focusTimerViewModel.elapsedTimeToString())
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.black)
                    .padding([.top], 4)

                Text("(\(focusTimerViewModel.elapsedTimeToString()))")
                    .font(.system(size: 16, weight: .heavy))
                    .foregroundColor(FancyColor.gray2.color)
                    .padding([.bottom], 50)

                FancyButton(
                    title: "잠깐 쉴래요",
                    action: {
                        Foast.show(message: "정지하려면 길게 누르세요.")
                    },
                    longPressAction: {
                        withAnimation {
                            tabBarManager.isTabBarVisible = true
                            focusTimerViewModel.isStudying = false
                            timeTimerViewModel.focusTimerViewModel = nil
                            timeTimerViewModel.stopAndSaveStudySessionIfNeeded()
                        }
                    },
                    icon: Image("ic_pause"),
                    isBlock: false,
                    style: .constant(.black)
                )
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
                    .padding(.bottom, 40)
                    .padding(.trailing, 30)
                }
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
