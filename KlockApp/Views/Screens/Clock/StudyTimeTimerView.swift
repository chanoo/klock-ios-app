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
        GeometryReader { geometry in
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
                            .padding(24)
                    }
                }
                Spacer()
                Button(action: {
                    isShowingClockModal.toggle()
                }) {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(FancyColor.primary.color)
                }
                Spacer()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .background(FancyColor.background.color)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 0)
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
