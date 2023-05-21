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
                
                Text("\(focusTimerViewModel.model.name)")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                Text(focusTimerViewModel.elapsedTimeToString())
                    .font(.largeTitle)
                    .padding()
                    .background(.white.opacity(0.5))
                    .foregroundColor(.gray.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

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
                        clockSize: CGSize(width: 300, height: 300),
                        hourHandColor: .black,
                        minuteHandColor: .black,
                        secondHandColor: .pink,
                        outlineInColor: .white.opacity(0.8),
                        outlineOutColor: .white.opacity(0.5)
                    )
                )
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
                            focusTimerViewModel.isStudying = false
                            timeTimerViewModel.focusTimerViewModel = nil
                            timeTimerViewModel.stopAndSaveStudySessionIfNeeded()
                        }
                    },
                    backgroundColor: .white.opacity(0.4),
                    foregroundColor: .pink.opacity(0.5),
                    isBlock: false
                )

            }

        }
        .background(FancyColor.background.color)
        .frame(width: geometry.size.width, height: geometry.size.height)
        .onAppear {
            timeTimerViewModel.startStudySession()
            timeTimerViewModel.playVibration()
        }
    }
}

struct FocusTimerView_Previews: PreviewProvider {
    static var previews: some View {
        let model = FocusTimerModel(id: 1, userId: 1, seq: 1, type: "FOCUS", name: "집중시간 타이머")
        let viewModel = FocusTimerViewModel(model: model)
        FocusTimerView()
            .environmentObject(viewModel)
    }
}
