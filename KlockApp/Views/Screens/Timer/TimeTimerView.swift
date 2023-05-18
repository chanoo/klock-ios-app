//
//  TimeTimerView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/12.
//

import SwiftUI
import UniformTypeIdentifiers
import Lottie

// 주 타이머 화면 뷰
struct TimeTimerView: View {
    @EnvironmentObject var viewModel: TimeTimerViewModel // 환경 객체로 타이머 뷰 모델을 가져옵니다.
    @State private var isShowingSelectTimer = false // 타이머 선택 화면의 표시 여부를 결정하는 상태 변수입니다.

    // body에서 조건 분기를 통해 로딩 화면과 메인 화면을 나눕니다.
    var body: some View {
        if viewModel.isLoading {
            loadingView
        } else {
            mainView
        }
    }

    // 로딩 화면을 나타내는 뷰입니다.
    private var loadingView: some View {
        ProgressView()
    }

    // 메인 화면을 나타내는 뷰입니다.
    private var mainView: some View {
        GeometryReader { geometry in
            ZStack {
                TimerTabView(geometry: geometry, isShowingSelectTimer: $isShowingSelectTimer)
                
                // FocusTimerView, PomodoroTimerView, ExamTimerView에 대한 조건문입니다.
                // 해당 타이머 모델이 nil이 아니라면 해당 타이머 뷰를 표시합니다.
                if let focusTimerViewModel = viewModel.focusTimerViewModel {
                    FocusTimerView()
                        .environmentObject(focusTimerViewModel)
                        .defaultTimerViewSettings(geometry: geometry, animation: viewModel.animation)
                }
                
                if let pomodoroTimerViewModel = viewModel.pomodoroTimerViewModel {
                    PomodoroTimerView()
                        .environmentObject(pomodoroTimerViewModel)
                        .defaultTimerViewSettings(geometry: geometry, animation: viewModel.animation)
                }
                
                if let examTimerViewModel = viewModel.examTimerViewModel {
                    ExamTimerView()
                        .environmentObject(examTimerViewModel)
                        .defaultTimerViewSettings(geometry: geometry, animation: viewModel.animation)
                }
            }
        }
    }
}

// TabView 내의 타이머 카드들을 표시하는 뷰입니다.
struct TimerTabView: View {
    var geometry: GeometryProxy
    @Binding var isShowingSelectTimer: Bool
    @EnvironmentObject var viewModel: TimeTimerViewModel

    var body: some View {
        VStack {
            TabView {
                ForEach(viewModel.timerCardViews.indices, id: \.self) { index in
                    VStack {
                        viewModel.timerCardViews[index]
                            .environmentObject(self.viewModel)
                            .frame(width: geometry.size.width - 30, height: geometry.size.height - 30)
                            .onDrag {
                                NSItemProvider(object: String(index) as NSString)
                            }
                            .onDrop(of: [UTType.text], delegate: viewModel.dropDelegate(for: index))
                    }
                }
                AddTimerButton(geometry: geometry, isShowingSelectTimer: $isShowingSelectTimer)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            Spacer()
        }
        .zIndex(1)
        .navigationBarTitle("타임 타이머", displayMode: .inline)
        .navigationBarItems(
            trailing: Button(action: { isShowingSelectTimer.toggle() }) {
                Image(systemName: "plus")
            }
        )
        .sheet(isPresented: $isShowingSelectTimer) {
            SelectTimerView()
                .environmentObject(self.viewModel)
        }
    }
}

// 타이머를 추가하는 버튼을 표시하는 뷰입니다.
struct AddTimerButton: View {
    var geometry: GeometryProxy
    @Binding var isShowingSelectTimer: Bool
    
    var body: some View {
        Button(action: { isShowingSelectTimer.toggle() }) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(FancyColor.background.color)
                    .frame(width: geometry.size.width - 30, height: geometry.size.height - 30)
                    .shadow(color: Color(.systemGray).opacity(0.2), radius: 5, x: 0, y: 0)

                LottieView(name: "lottie-plus")
                    .frame(width: 128, height: 128)
            }
        }
    }
}

// 기본 타이머 뷰 설정을 적용하는 뷰 수정자(View Modifier)
extension View {
    func defaultTimerViewSettings(geometry: GeometryProxy, animation: Namespace.ID) -> some View {
        self
            .frame(width: .infinity, height: .infinity)
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
            .zIndex(2)
    }
}

struct TimeTimerView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: Container.shared.resolve(ContentViewModel.self))
            .environmentObject(Container.shared.resolve(TimeTimerViewModel.self))
    }
}

