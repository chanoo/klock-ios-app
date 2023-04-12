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
        VStack {
            Text("공부 시간 타이머")
            Button(action: {
                isShowingClockModal.toggle()
            }) {
                Image(systemName: "play.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)
            }
        }
        .sheet(isPresented: $isShowingClockModal) {
            ClockModalView()
        }
    }
}

struct StudyTimerView_Previews: PreviewProvider {
    static var previews: some View {
        StudyTimerView()
    }
}
