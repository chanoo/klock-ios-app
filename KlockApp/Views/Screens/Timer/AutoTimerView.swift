//
//  AutoTimerView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/07/18.
//

import SwiftUI
import Foast

struct AutoTimerView: View {
    @EnvironmentObject var tabBarManager: TabBarManager
    @EnvironmentObject var autoTimerViewModel: AutoTimerViewModel
    @EnvironmentObject var timeTimerViewModel: TimeTimerViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var chatBotViewModel: ChatBotViewModel
    @State private var showChatBot = false
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var backgroundEnterTime: Date?

    var body: some View {
        GeometryReader { geometry in
            frontView(geometry: geometry)
        }
    }
    
    private func frontView(geometry: GeometryProxy) -> some View {
        ZStack(alignment: .center) {
            backgroundImageView(with: geometry)
            warningImageView(with: geometry)
            mainContentView(with: geometry)
            chatBotButton(with: geometry)
        }
        .background(FancyColor.timerFocusBackground.color)
        .onAppear(perform: onAppearActions)
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            autoTimerViewModel.appWillEnterForeground()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
            self.autoTimerViewModel.appDidEnterBackground()
        }
        .onReceive(timer, perform: updateCurrentTime)
        .onReceive(autoTimerViewModel.$inferenceStatus, perform: autoTimerViewModel.updateInferenceStatus)
        .onReceive(autoTimerViewModel.$noPersonDetectedFor10Seconds, perform: handleNoPersonDetected)
    }
    
    private func onAppearActions() {
        UIApplication.shared.isIdleTimerDisabled = true
        autoTimerViewModel.startStudy()
        timeTimerViewModel.startStudySession()
        timeTimerViewModel.playVibration()
    }
    
    private func updateCurrentTime(_ time: Date) {
        if autoTimerViewModel.isRunning {
            autoTimerViewModel.currentTime = autoTimerViewModel.currentTime.addingTimeInterval(1)
            if autoTimerViewModel.isStudying {
                autoTimerViewModel.elapsedTime = autoTimerViewModel.currentTime.timeIntervalSince(autoTimerViewModel.startTime)
            }
        }
    }
    
    private func handleNoPersonDetected(_ shouldStop: Bool) {
        if shouldStop {
            stopAndSaveStudySession()
        }
    }
    
    private func stopAndSaveStudySession() {
        withAnimation {
            tabBarManager.show()
            autoTimerViewModel.stopStudy()
            timeTimerViewModel.stopAndSaveStudySession(
                timerName: autoTimerViewModel.model.name,
                timerType: .auto,
                startTime: autoTimerViewModel.startTime,
                endTime: autoTimerViewModel.currentTime
            )
            let model = MyModel.shared
            model.stopMonitoring()
            timeTimerViewModel.autoTimerViewModel = nil
        }
    }
}

extension AutoTimerView {
    private func backgroundImageView(with geometry: GeometryProxy) -> some View {
        Group {
            if let originalImage = autoTimerViewModel.originalImage {
                Image(uiImage: originalImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
//                    .overlay(
//                        (autoTimerViewModel.resultImage != nil) ?
//                            Image(uiImage: autoTimerViewModel.resultImage!)
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: geometry.size.width, height: geometry.size.height)
//                                .opacity(0.2)
//                            : nil
//                    )
            } else {
                PlaceholderImage()
            }
        }
    }
    
    private func warningImageView(with geometry: GeometryProxy) -> some View {
        Group {
            VStack {
                if autoTimerViewModel.elapsedSecondsWithoutPerson >= 5 {
                    Spacer()
                    ZStack {
                        // 배경 원
                        Circle()
                            .stroke(Color.gray.opacity(0.2), lineWidth: 5) // 이 원은 프로그레스 원의 배경으로 작동합니다.
                            .frame(width: 120, height: 120)

                        // 프로그레스 원
                        ProgressCircle(progress: CGFloat(autoTimerViewModel.countdownText()) / 5.0)
                            .stroke(FancyColor.primary.color, lineWidth: 5)
                            .frame(width: 120, height: 120)

                        Text("\(autoTimerViewModel.countdownText())")
                            .font(.system(size: 48, weight: .semibold))
                            .monospacedDigit()
                            .foregroundColor(FancyColor.white.color)
                    }
                    .padding(.top, Constants.bottomLargePadding)
                    Spacer()
                    Text("*신체가 조금만 보여도 인식이 가능해요!\n*신체가 보이지 않으면 10초 후 자동 종료됩니다.")
                        .font(.system(size: 17, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(FancyColor.white.color)
                        .padding(.bottom, Constants.bottomLargePadding)
                }
            }
        }
    }

    private func mainContentView(with geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            VStack {
                Text(autoTimerViewModel.model.name)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(FancyColor.black.color)

                Text(autoTimerViewModel.elapsedTimeToString())
                    .font(.system(size: 20, weight: .bold))
                    .monospacedDigit()
                    .foregroundColor(FancyColor.black.color)
            }
            .padding([.top, .bottom], 18)
            .padding([.leading, .trailing], 24)
            .background(FancyColor.primary.color)
            .cornerRadius(4.0)
            .padding(.top, Constants.topPadding)

//            Text(autoTimerViewModel.inferenceStatus)
//                .multilineTextAlignment(.center)

            Spacer()

            pauseButton
                .padding(.top, Constants.topMediumPadding)
                .padding(.bottom, Constants.bottomPadding)
        }
        .frame(width: geometry.size.width, height: geometry.size.height)
    }

    private var pauseButton: some View {
        FancyButton(
            title: "잠깐 쉴래요",
            action: {
                Foast.show(message: "정지하려면 길게 누르세요.")
            },
            longPressAction: stopAndSaveStudySession,
            icon: Image("ic_pause"),
            isBlock: false,
            style: .constant(.black)
        )
    }

    private func chatBotButton(with geometry: GeometryProxy) -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    showChatBot = true
                } label: {
                    Image("ic_star_balloon")
                }
                .padding(.bottom, Constants.chatbotBottomPadding)
                .padding(.trailing, Constants.chatbotTrailingPadding)
            }
            .padding(.bottom, 19)
            .shadow(color: Color(.systemGray).opacity(0.2), radius: 5, x: 0, y: 0)
            .sheet(isPresented: $showChatBot) {
                NavigationView {
                    ChatBotListView()
                        .environmentObject(chatBotViewModel)
                }
            }
        }
    }
}

private struct Constants {
    static let topPadding: CGFloat = 80
    static let topSmallPadding: CGFloat = 2
    static let topMediumPadding: CGFloat = 40
    static let mediumPadding: CGFloat = 40
    static let bottomPadding: CGFloat = 80
    static let bottomLargePadding: CGFloat = 160
    static let chatbotBottomPadding: CGFloat = 60
    static let chatbotTrailingPadding: CGFloat = 30
}

struct ProgressCircle: Shape {
    var progress: Double

    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                    radius: rect.width / 2,
                    startAngle: Angle(degrees: -90),
                    endAngle: Angle(degrees: (-90) + (360 * progress)),
                    clockwise: false)
        
        return path
    }
}

struct PlaceholderImage: View {
    var body: some View {
        Rectangle()
            .overlay(
                Text("준비 중...")
                    .foregroundColor(.white)
            )
    }
}

struct AutoTimerView_Previews: PreviewProvider {
    static var previews: some View {
        let model = AutoTimerModel(id: 1, userId: 1, seq: 1, type: "AUTO", name: "자동 집중시간 타이머")
        let autoTimerViewModel = AutoTimerViewModel(model: model)
        let TimeTimerViewModel = Container.shared.resolve(TimeTimerViewModel.self)
        let TabBarManager = Container.shared.resolve(TabBarManager.self)

        AutoTimerView()
            .environmentObject(autoTimerViewModel)
            .environmentObject(TimeTimerViewModel)
            .environmentObject(TabBarManager)
    }
}
