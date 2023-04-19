//
//  StudyTimerView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/12.
//

import SwiftUI

struct StudyTimerView: View {
    @StateObject private var viewModel: ClockViewModel = Container.shared.resolve(ClockViewModel.self)
    @State private var isShowingClockModal = false

    var body: some View {
        GeometryReader { geometry in
            VStack {
                if viewModel.isDark {
                    Text("공부 시간 타이머")
                        .onAppear {
                            if !isShowingClockModal {
                                isShowingClockModal.toggle()
                            }
                            viewModel.playVibration()
                            NotificationManager.sendLocalNotification()
                        }
                } else {
                    Text("밝은 환경")
                }
                Button(action: {
                    viewModel.loadStudyTime()
                    isShowingClockModal.toggle()
                }) {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(FancyColor.primary.color)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .sheet(isPresented: $isShowingClockModal) {
            AnalogClockView()
        }
    }
}

struct StudyTimerView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: Container.shared.resolve(ContentViewModel.self))
    }
}
