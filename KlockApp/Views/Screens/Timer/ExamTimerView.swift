//
//  ExamTimerView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/21.
//

import SwiftUI
import Foast

struct ExamTimerView: View {
    
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
        }
        .background(FancyColor.background.color)
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
                    isRunning: true,
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
                    title: "잠시 멈춤",
                    action: {
                        withAnimation {
                            tabBarManager.isTabBarVisible = true
                            examTimerViewModel.isStudying = false
                            timeTimerViewModel.examTimerViewModel = nil
                        }
                    },
                    backgroundColor: .white.opacity(0.4),
                    foregroundColor: .pink.opacity(0.5),
                    isBlock: false
                )
            }
        }
        .background(FancyColor.background.color)
        .matchedGeometryEffect(id: "TimerView", in: timeTimerViewModel.animation)
        .frame(width: geometry.size.width, height: geometry.size.height)
    }
}

//struct ExamTimeTimerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExamTimeTimerView(model: <#T##ExamTimerModel#>)
//    }
//}
