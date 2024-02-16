//
//  AutoTimerCardView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/07/18.
//

import SwiftUI

struct AutoTimerCardView: View {
    @EnvironmentObject var tabBarManager: TabBarManager
    @EnvironmentObject var actionSheetManager: ActionSheetManager
    @StateObject var timerModel: TimerModel
    @StateObject var autoTimerViewModel: AutoTimerViewModel
    @StateObject var timeTimerViewModel: TimeTimerViewModel
    @State private var isFlipped: Bool = false

    private func flipAnimation() {
        withAnimation(.spring()) {
            isFlipped.toggle()
        }
    }

    var body: some View {
        GeometryReader { geometry in
            frontView(geometry: geometry)
                .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0.0, y: 1.0, z: 0.0))
                .opacity(isFlipped ? 0 : 1)
            
            backView(geometry: geometry)
                .rotation3DEffect(.degrees(isFlipped ? 0 : 180), axis: (x: 0.0, y: 1.0, z: 0.0))
                .opacity(isFlipped ? 1 : 0)
        }
        .cornerRadius(10)
        .shadow(color: Color(.systemGray).opacity(0.2), radius: 5, x: 0, y: 0)
    }
    
    private func frontView(geometry: GeometryProxy) -> some View {
        ZStack(alignment: .center) {
//            Image("img_watch_background3")
//                .aspectRatio(contentMode: .fill)
//                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)

            Button(action: {
                flipAnimation()
                tabBarManager.hide()
            }) {
                Image("ic_3dots")
                    .foregroundColor(FancyColor.gray3.color)
            }
            .position(x: geometry.size.width - 30, y: 30)
            
            VStack(spacing: 0) {
                Spacer()
                Image("img_circle_ai_charactor")
                    .resizable()
                    .frame(width: 260, height: 260)
                Spacer()

                Text(autoTimerViewModel.model.name)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(FancyColor.timerFocusText.color)
                
                Text(autoTimerViewModel.elapsedTimeToString())
                    .font(.system(size: 40, weight: .bold))
                    .monospacedDigit()
                    .foregroundColor(FancyColor.timerFocusText.color)
                    .padding([.top], 4)
                
                if autoTimerViewModel.cameraPermissionGranted {
                    FancyButton(
                        title: "자동으로 기록",
                        action: {
                            withAnimation {
                                tabBarManager.hide()
                                timeTimerViewModel.autoTimerViewModel = autoTimerViewModel
                                let appUsageController = AppUsageController.shared
                                appUsageController.initiateMonitoring()
                            }
                        },
                        icon: Image("ic_play"),
                        isBlock: false,
                        style: .constant(.black)
                    )
                    .padding(.top, 30)
                    .padding(.bottom, 60)
                } else {
                    NavigationLink(
                        destination: CameraPermissionView().environmentObject(actionSheetManager),
                        isActive: $autoTimerViewModel.isShowCemeraPermissionView)
                    {
                        FancyButton(
                            title: "자동으로 기록",
                            action: {
                                autoTimerViewModel.showCameraPermissionView()
                            },
                            icon: Image("ic_play"),
                            isBlock: false,
                            style: .constant(.black)
                        )
                        .padding(.top, 30)
                        .padding(.bottom, 60)
                    }
                }
            }
        }
        .background(FancyColor.timerFocusBackground.color)
        .onAppear {
            autoTimerViewModel.checkCameraPermission()
        }
    }

    private func backView(geometry: GeometryProxy) -> some View {
        VStack {
            List {
                Section(header: Text("집중시간 타이머 설정")) {
                    VStack(alignment: .leading) {
                        Text("과목명")
                            .font(.headline)
                            .foregroundColor(.gray)
                        TextField("어떤 공부를 할건가요?", text: $autoTimerViewModel.model.name)
                    }
                }

                Section {
                    Button(action: {
                        timeTimerViewModel.update(type: TimerType.auto.rawValue, model: autoTimerViewModel.model)
                        flipAnimation()
                        tabBarManager.show()
                    }) {
                        Text("저장")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }

                Section {
                    Button(action: {
                        flipAnimation()
                        tabBarManager.show()
                    }) {
                        Text("취소")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }

                Section {
                    Button(action: {
                        flipAnimation()
                        tabBarManager.show()
                        timeTimerViewModel.delete(model: autoTimerViewModel.model)
                    }) {
                        Text("삭제")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(FancyColor.secondary.color)
                    }
                }
            }
            .clearListBackground()
        }
        .background(FancyColor.chatBotBackground.color)
    }

}

struct AutoTimerCardView_Previews: PreviewProvider {
    static var previews: some View {
        let timerModel = TimerModel(id: 1, userId: 1, seq: 1, type: "AUTO", name: "국어")
        let model = AutoTimerModel(id: 1, userId: 1, seq: 1, type: TimerType.auto.rawValue, name: "자동 집중시간 타이머")
        let viewModel = AutoTimerViewModel(model: model)
        let timeTimerViewModel = Container.shared.resolve(TimeTimerViewModel.self)
        AutoTimerCardView(timerModel: timerModel, autoTimerViewModel: viewModel, timeTimerViewModel: timeTimerViewModel)
    }
}
