//
//  StudyTimeTimerView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/21.
//

import SwiftUI
import Foast

struct FocusTimerView2: View {
    @ObservedObject var model: FocusTimerModel
    @EnvironmentObject var viewModel: TimeTimerViewModel
    @Namespace private var animation
    @State private var selectedCardItem: FocusTimerModel? = nil

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
        .onAppear {
            if viewModel.isDark && !viewModel.isShowingClockModal {
                viewModel.isShowingClockModal.toggle()
                viewModel.playVibration()
                NotificationManager.sendLocalNotification()
            }
        }
        .sheet(isPresented: $viewModel.isShowingClockModal) {}
    }

    private func frontView(geometry: GeometryProxy) -> some View {
        ZStack {
            VStack {
                AnalogClockView(
                    currentTime: Date(),
                    startTime: Date(),
                    elapsedTime: $viewModel.elapsedTime,
                    studySessions: .constant([]),
                    isStudying: $viewModel.isStudying,
                    isRunning: true,
                    clockModel: ClockModel(
                        hourHandImageName: "img_watch_hand_hour",
                        minuteHandImageName: "img_watch_hand_min",
                        secondHandImageName: "img_watch_hand_sec",
                        clockBackgroundImageName: "img_watch_face1",
                        clockSize: CGSize(width: 300, height: 300),
                        hourHandColor: .black,
                        minuteHandColor: .black,
                        secondHandColor: .pink,
                        outlineInColor: .white,
                        outlineOutColor: .white
                    ),
                    hour: 10,
                    minute: 20,
                    second: 35
                )
                .previewLayout(.sizeThatFits)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: flipAnimation) {
                        Image(systemName: "gearshape")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    .padding(.top, 16)
                    .padding(.trailing, 16)
                }
                Spacer()
            }
        }
        .background(FancyColor.background.color)
        .cornerRadius(10)
        .shadow(color: Color(.systemGray).opacity(0.2), radius: 5, x: 0, y: 0)
    }

    private func backView(geometry: GeometryProxy) -> some View {
        VStack {
            List {
                Section(header: Text("공부시간 설정")) {
                    VStack(alignment: .leading) {
                        Text("공부")
                            .font(.headline)
                            .foregroundColor(.gray)
                        TextField("어떤 공부를 할건가요?", text: $model.name)
                    }
                }

                Section {
                    Button(action: {
                        flipAnimation()
                    }) {
                        Text("저장")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }

                Section {
                    Button(action: {
                        flipAnimation()
                    }) {
                        Text("취소")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }

                Section {
                    Button(action: {
                        flipAnimation()
                        viewModel.delete(model: model)
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

struct StudyTimeTimerView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = Container.shared.resolve(TimeTimerViewModel.self)
        let model = FocusTimerModel(id: 1, userId: 2, seq: 1, type: "FOCUS", name: "집중시간 타이머")
        FocusTimerView2(model: model)
            .environmentObject(viewModel)
    }
}
