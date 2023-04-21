//
//  StudyTimeTimerView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/21.
//

import SwiftUI

struct StudyTimeTimerView: View {
    
    @StateObject private var viewModel: ClockViewModel = Container.shared.resolve(ClockViewModel.self)
    @State private var isShowingClockModal = false

    var body: some View {
        VStack {
            Button(action: {
                isShowingClockModal.toggle()
            }) {
                Image(systemName: "play.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(FancyColor.primary.color)
            }
        }
        .onAppear {
            if viewModel.isDark && !isShowingClockModal {
                isShowingClockModal.toggle()
                viewModel.playVibration()
                NotificationManager.sendLocalNotification()
            }
        }
        .sheet(isPresented: $isShowingClockModal) {
            AnalogClockView()
        }
    }
}

struct StudyTimeTimerView_Previews: PreviewProvider {
    static var previews: some View {
        StudyTimeTimerView()
    }
}
