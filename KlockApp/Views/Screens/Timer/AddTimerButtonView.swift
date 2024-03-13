//
//  AddTimerButtonView.swift
//  KlockApp
//
//  Created by 성찬우 on 3/10/24.
//

import SwiftUI

// 타이머를 추가하는 버튼을 표시하는 뷰입니다.
struct AddTimerButtonView: View {
    @EnvironmentObject var actionSheetManager: ActionSheetManager
    @ObservedObject var viewModel: TimeTimerViewModel
    
    var body: some View {
        Button(action: {
            actionSheetManager.actionSheet = CustomActionSheetView(
                title: "공부시간 타이머 추가",
                message: "원하는 타이머로 공부를 시작해보세요.",
                actionButtons: [
                    FancyButton(title: "집중시간 타이머", action: {
                        viewModel.addTimer(type: TimerType.focus.rawValue)
                        actionSheetManager.isPresented = false
                    }, style: .constant(.outline)),
                    FancyButton(title: "Ai자동 타이머", action: {
                        viewModel.addTimer(type: TimerType.auto.rawValue)
                        actionSheetManager.isPresented = false
                    }, style: .constant(.outline)),
//                    ActionButton(title: "뽀모도로 타이머", action: {
//                        withAnimation(.spring()) {
//                            viewModel.addTimer(type: TimerType.pomodoro.rawValue)
//                            actionSheetManager.isPresented = false
//                        }
//                    }),
//                    ActionButton(title: "시험시간 타이머", action: {
//                        withAnimation(.spring()) {
//                            viewModel.addTimer(type: TimerType.exam.rawValue)
//                            actionSheetManager.isPresented = false
//                        }
//                    }),
                ],
                cancelButton: FancyButton(title: "취소", action: {
                    actionSheetManager.isPresented = false
                }, style: .constant(.text))
            )
            withAnimation(.spring()) {
                actionSheetManager.isPresented = true
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(FancyColor.timerFocusBackground.color)
                    .shadow(color: Color(.systemGray).opacity(0.2), radius: 5, x: 0, y: 0)

                LottieView(name: "lottie-plus")
                    .frame(width: 128, height: 128)
                    .shadow(color: Color(.systemGray).opacity(0.2), radius: 5, x: 0, y: 0)
                
                Text("원하는 타이머로 공부를 시작해보세요")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(FancyColor.gray3.color)
                    .padding(.top, 200)
            }
        }
    }
}
