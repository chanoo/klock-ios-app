//
//  StudyTimerView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/12.
//

import SwiftUI

struct StudyTimerView: View {
    @State private var isShowingClockModal = false

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("공부 시간 타이머")
                Button(action: {
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
        StudyTimerView()
    }
}
