//
//  TimeTimerView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/12.
//

import SwiftUI
import UniformTypeIdentifiers
import Lottie
import FamilyControls

// 주 타이머 화면 뷰
struct TimeTimerView: View {
    @EnvironmentObject var tabBarManager: TabBarManager
    @StateObject var viewModel = Container.shared.resolve(TimeTimerViewModel.self)
    @StateObject var chatBotViewModel = Container.shared.resolve(ChatBotViewModel.self)
    @State private var isShowingSelectTimer = false // 타이머 선택 화면의 표시 여부를 결정하는 상태 변수입니다.
    
    // body에서 조건 분기를 통해 로딩 화면과 메인 화면을 나눕니다.
    var body: some View {
        mainView
    }

    // 메인 화면을 나타내는 뷰입니다.
    private var mainView: some View {
        GeometryReader { geometry in
            ZStack {
                TimerTabView(viewModel: viewModel, geometry: geometry, isShowingSelectTimer: $isShowingSelectTimer)
                    .environmentObject(tabBarManager)

                // FocusTimerView, PomodoroTimerView, ExamTimerView에 대한 조건문입니다.
                // 해당 타이머 모델이 nil이 아니라면 해당 타이머 뷰를 표시합니다.
                if let focusTimerViewModel = viewModel.focusTimerViewModel {
                    FocusTimerView(timeTimerViewModel: viewModel)
                        .environmentObject(focusTimerViewModel)
                        .environmentObject(tabBarManager)
                        .defaultTimerViewSettings(geometry: geometry, animation: viewModel.animation)
                }
                
                if let pomodoroTimerViewModel = viewModel.pomodoroTimerViewModel {
                    PomodoroTimerView()
                        .environmentObject(pomodoroTimerViewModel)
                        .environmentObject(tabBarManager)
                        .defaultTimerViewSettings(geometry: geometry, animation: viewModel.animation)
                }
                
                if let examTimerViewModel = viewModel.examTimerViewModel {
                    ExamTimerView()
                        .environmentObject(examTimerViewModel)
                        .environmentObject(tabBarManager)
                        .defaultTimerViewSettings(geometry: geometry, animation: viewModel.animation)
                }
                
                if let autoTimerViewModel = viewModel.autoTimerViewModel {
                    AutoTimerView(timeTimerViewModel: viewModel)
                        .environmentObject(autoTimerViewModel)
                        .environmentObject(tabBarManager)
                        .defaultTimerViewSettings(geometry: geometry, animation: viewModel.animation)
                }
            }
        }
    }
}

// TabView 내의 타이머 카드들을 표시하는 뷰입니다.
struct TimerTabView: View {
    @ObservedObject var viewModel: TimeTimerViewModel
    var geometry: GeometryProxy
    @Binding var isShowingSelectTimer: Bool
    @EnvironmentObject var tabBarManager: TabBarManager

    // 로딩 화면을 나타내는 뷰입니다.
    private var loadingView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(FancyColor.timerFocusBackground.color)
                .frame(width: geometry.size.width - 30, height: geometry.size.height - 30)
                .shadow(color: Color(.systemGray).opacity(0.2), radius: 5, x: 0, y: 0)

            TimerLoadingView()
                .onAppear {
                    viewModel.loadTimer()
                }
        }
    }

    var body: some View {
        VStack {
            TabView {
                if viewModel.isLoading {
                    VStack {
                        loadingView
                    }
                } else {
                    ForEach(viewModel.timerCardViews.indices, id: \.self) { index in
                        VStack {
                            viewModel.timerCardViews[index]
                                .environmentObject(viewModel)
                                .environmentObject(tabBarManager)
                                .frame(width: geometry.size.width - 30, height: geometry.size.height - 30)
    //                            .onDrag {
    //                                NSItemProvider(object: String(index) as NSString)
    //                            }
    //                            .onDrop(of: [UTType.text], delegate: viewModel.dropDelegate(for: index))
                        }
                    }
                    AddTimerButton(geometry: geometry, isShowingSelectTimer: $isShowingSelectTimer)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))

            Spacer()
        }
        .zIndex(1)
        .navigationBarTitle("공부시간 타이머", displayMode: .inline)
//        .navigationBarItems(
//            trailing: Button(action: { isShowingSelectTimer.toggle() }) {
//                Image(systemName: "plus")
//            }
//        )
    }
}

// 타이머를 추가하는 버튼을 표시하는 뷰입니다.
struct AddTimerButton: View {
    @EnvironmentObject var tabBarManager: TabBarManager
    @EnvironmentObject var actionSheetManager: ActionSheetManager
    @EnvironmentObject var viewModel: TimeTimerViewModel
    var geometry: GeometryProxy
    @Binding var isShowingSelectTimer: Bool
    
    var body: some View {
        Button(action: {
            tabBarManager.show()
            actionSheetManager.actionSheet = CustomActionSheetView(
                title: "공부시간 타이머 추가",
                message: "원하는 타이머로 공부를 시작해보세요.",
                actionButtons: [
                    FancyButton(title: "집중시간 타이머", action: {
                        viewModel.addTimer(type: TimerType.focus.rawValue)
                        actionSheetManager.isPresented = false
                    }, style: .constant(.outline)),
                    FancyButton(title: "Ai 자동 타이머", action: {
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
                    .frame(width: geometry.size.width - 30, height: geometry.size.height - 30)
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

// 기본 타이머 뷰 설정을 적용하는 뷰 수정자(View Modifier)
extension View {
    func defaultTimerViewSettings(geometry: GeometryProxy, animation: Namespace.ID) -> some View {
        self
            .ignoresSafeArea()
            .frame(width: .infinity, height: .infinity)
            .navigationBarHidden(true)
            .zIndex(10)
    }
}

struct TimeTimerView_Previews: PreviewProvider {
    static var previews: some View {
        let appFlowManager = Container.shared.resolve(AppFlowManager.self)
        ContentView(viewModel: Container.shared.resolve(ContentViewModel.self))
            .environmentObject(appFlowManager)
            .environmentObject(Container.shared.resolve(TimeTimerViewModel.self))
    }
}

