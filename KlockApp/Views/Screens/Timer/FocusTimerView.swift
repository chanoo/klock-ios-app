//
//  FocusTimerView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/05/16.
//

import SwiftUI

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
                
                Text(timeTimerViewModel.elapsedTimeToString())
                    .font(.largeTitle)
                    .padding()
                    .background(.white.opacity(0.5))
                    .foregroundColor(.gray.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                AnalogClockView(
                    currentTime: Date(),
                    startTime: Date(),
                    elapsedTime: $focusTimerViewModel.elapsedTime,
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
                        secondHandColor: .pink,
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
                    title: "잠시 멈춤",
                    action: {
                        withAnimation {
                            tabBarManager.isTabBarVisible.toggle()
                            timeTimerViewModel.isStudying.toggle()
                            timeTimerViewModel.focusTimerModel = nil
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
    }
}

struct FocusTimerView_Previews: PreviewProvider {
    static var previews: some View {
        let model = FocusTimerModel(id: 1, userId: 1, seq: 1, type: "focus", name: "집중시간 타이머")
        let viewModel = FocusTimerViewModel(model: model)
        FocusTimerView()
            .environmentObject(viewModel)
    }
}
