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
    @ObservedObject var clockViewModel = ClockViewModel(
        currentTime: Date(),
        startTime: Date(),
        elapsedTime: 0,
        isStudying: false,
        isRunning: true
    )
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
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
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)

            Button(action: flipAnimation) {
                Image(systemName: "gearshape")
                    .frame(width: 20, height: 20)
            }
            .position(x: geometry.size.width - 25, y: 25)

            VStack {
                
                Text(examTimerViewModel.elapsedTimeToString())
                    .font(.largeTitle)
                    .padding()
                    .background(.white.opacity(0.5))
                    .foregroundColor(.gray.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                AnalogClockView(
                    timer: timer,
                    clockViewModel: clockViewModel,
                    analogClockModel: AnalogClockModel(
                        hourHandImageName: "img_watch_hand_hour",
                        minuteHandImageName: "img_watch_hand_min",
                        secondHandImageName: "img_watch_hand_sec",
                        clockBackgroundImageName: "img_watch_face1",
                        clockSize: CGSize(width: 300, height: 300),
                        hourHandColor: .black,
                        minuteHandColor: .black,
                        secondHandColor: .cyan,
                        outlineInColor: .white.opacity(0.8),
                        outlineOutColor: .white.opacity(0.5)
                    )
                )
                .environmentObject(clockViewModel)
                .padding(.top, 20)
                .padding(.bottom, 20)

                FancyButton(title: "시험 시작", action: {
                    withAnimation {
                        clockViewModel.startStudy()
                        tabBarManager.hide()
                        examTimerViewModel.isStudying = true
                        timeTimerViewModel.startStudySession(timerName: examTimerViewModel.model.name)
                        timeTimerViewModel.examTimerViewModel = examTimerViewModel
                    }
                }, style: .constant(.primary))
            }
        }
        .background(FancyColor.background.color)
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
                        Text("시험 시작시간")
                            .font(.headline)
                            .foregroundColor(.gray)
                        DatePicker("", selection: $examTimerViewModel.model.startTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()
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
                
                Section {
                    Button(action: {
                        // Save settings
                        withAnimation(.spring()) {
                            flipAnimation()
                            timeTimerViewModel.update(type: TimerType.exam.rawValue, model: examTimerViewModel.model)
                        }
                    }) {
                        Text("저장")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                
                Section {
                    Button(action: {
                        withAnimation(.spring()) {
                            isFlipped.toggle()
                        }
                    }) {
                        Text("취소")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                
                Section {
                    Button(action: {
                        withAnimation(.spring()) {
                            flipAnimation()
                            timeTimerViewModel.delete(model: examTimerViewModel.model)
                        }
                    }) {
                        Text("삭제")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(FancyColor.secondary.color)
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
        let model = ExamTimerModel(id: 1, userId: 1, seq: 1, type: TimerType.exam.rawValue, name: "시험시간 타이머", startTime: Date(), duration: 80, questionCount: 45, markingTime: 5)
        let viewModel = ExamTimerViewModel(model: model)
        ExamTimerCardView()
            .environmentObject(viewModel)
    }
}
