//
//  ExamTimerCardView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/05/18.
//

import SwiftUI
import Foast

struct ExamTimerCardView: View {
    
    @EnvironmentObject var examTimerViewModel: ExamTimerViewModel
    @EnvironmentObject var timeTimerViewModel: TimeTimerViewModel
    @EnvironmentObject var tabBarManager: TabBarManager

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
        .background(FancyColor.background.color)
        .cornerRadius(10)
        .shadow(color: Color(.systemGray).opacity(0.2), radius: 5, x: 0, y: 0)
    }
    
    private func frontView(geometry: GeometryProxy) -> some View {
        ZStack {
            
            Image("img_watch_background3")
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)

            VStack {
                
                Text(examTimerViewModel.elapsedTimeToString())
                    .font(.largeTitle)
                    .padding()
                    .background(.white.opacity(0.5))
                    .foregroundColor(.gray.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                AnalogClockView(
                    currentTime: Date(),
                    startTime: Date(),
                    elapsedTime: $examTimerViewModel.elapsedTime,
                    studySessions: .constant([]),
                    isStudying: $examTimerViewModel.isStudying,
                    isRunning: false,
                    clockModel: ClockModel(
                        hourHandImageName: "img_watch_hand_hour",
                        minuteHandImageName: "img_watch_hand_min",
                        secondHandImageName: "img_watch_hand_sec",
                        clockBackgroundImageName: "img_watch_face1",
                        clockSize: CGSize(width: 300, height: 300),
                        hourHandColor: .black,
                        minuteHandColor: .black,
                        secondHandColor: .orange,
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
                    title: "공부 시작",
                    action: {
                        withAnimation {
                            tabBarManager.isTabBarVisible = false
                            examTimerViewModel.isStudying = true
                            timeTimerViewModel.startStudySession()
                            timeTimerViewModel.examTimerViewModel = examTimerViewModel
                        }
                    },
                    backgroundColor: .white.opacity(0.4),
                    foregroundColor: .pink.opacity(0.5),
                    isBlock: false
                )
            }
            .overlay(
                Button(action: flipAnimation) {
                    Image(systemName: "gearshape")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .padding(.top, 16)
                .padding(.trailing, 16),
                alignment: .topTrailing // topTrailing은 오른쪽 상단을 의미합니다.
            )

        }
        .background(FancyColor.background.color)
        .matchedGeometryEffect(id: "TimerView", in: timeTimerViewModel.animation)
        .frame(width: geometry.size.width, height: geometry.size.height)
    }

    private func backView(geometry: GeometryProxy) -> some View {
        VStack {
            List {
                Section(header: Text("시험시간 설정")) {
                    VStack(alignment: .leading) {
                        Text("시험명")
                            .font(.headline)
                            .foregroundColor(.gray)
                        TextField("시험명을 입력해요.", text: $examTimerViewModel.model.name)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("시험 시간")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Stepper(value: $examTimerViewModel.model.duration, in: 5...240, step: 5) {
                            Text("\($examTimerViewModel.model.duration.wrappedValue)분")
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("마킹 시간")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Stepper(value: $examTimerViewModel.model.markingTime, in: 0...60, step: 5) {
                            Text("\($examTimerViewModel.model.markingTime.wrappedValue)분")
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("시험 문항수")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Stepper(value: $examTimerViewModel.model.questionCount, in: 1...120) {
                            Text("\($examTimerViewModel.model.questionCount.wrappedValue)개")
                        }
                    }
                }
            }
            .clearListBackground()
        }
        .background(FancyColor.background.color)
        .cornerRadius(10)
        .shadow(color: Color(.systemGray).opacity(0.2), radius: 5, x: 0, y: 0)
    }
}

struct ExamTimerCardView_Previews: PreviewProvider {
    static var previews: some View {
        let model = ExamTimerModel(id: 1, userId: 1, seq: 1, type: "EXAM", name: "시험시간 타이머", startTime: "", duration: 80, questionCount: 45, markingTime: 5)
        let viewModel = ExamTimerViewModel(model: model)
        ExamTimerCardView()
            .environmentObject(viewModel)
    }
}
