//
//  StudyTimeTimerView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/21.
//

import SwiftUI

struct StudyTimeTimerView: View {
    
    @EnvironmentObject var viewModel: TimeTimerViewModel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    AnalogClockView(
                        currentTime: Date(),
                        startTime: Date(),
                        elapsedTime: $viewModel.elapsedTime,
                        studySessions: .constant([]),
                        isStudying: $viewModel.isStudying,
                        isRunning: true,
                        clockModel:
                            ClockModel(
                                hourHandImageName: "img_watch_hand_hour",
                                minuteHandImageName: "img_watch_hand_min",
                                secondHandImageName: "img_watch_hand_sec",
                                clockBackgroundImageName: "img_watch_face1",
                                clockSize: CGSize(width: 300, height: 300)
                            ),
                        hour: 10,
                        minute: 20,
                        second: 35
                    )
                    .previewLayout(.sizeThatFits)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation(.spring()) {
                            }
                        }) {
                            Image(systemName: "gearshape")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                        .padding(.top, 16)
                        .padding(.trailing, 16)
                    }
                    Spacer()
                }
            }
        }
        .background(FancyColor.background.color)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 0)
        .onAppear {
            if viewModel.isDark && !viewModel.isShowingClockModal {
                viewModel.isShowingClockModal.toggle()
                viewModel.playVibration()
                NotificationManager.sendLocalNotification()
            }
        }
        .sheet(isPresented: $viewModel.isShowingClockModal) {
//            AnalogClockView()
        }
    }
}

struct StudyTimeTimerView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = Container.shared.resolve(TimeTimerViewModel.self)
        StudyTimeTimerView()
            .environmentObject(viewModel)
    }
}
