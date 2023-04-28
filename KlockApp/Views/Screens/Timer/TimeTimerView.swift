//
//  TimeTimerView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/12.
//

import SwiftUI
import UniformTypeIdentifiers
import Lottie

struct TimeTimerView: View {
    @EnvironmentObject var viewModel: TimeTimerViewModel
    @State private var isShowingSelectTimer = false

    var body: some View {
        if viewModel.isLoading {
            // 로딩 인디케이터를 표시
            ProgressView()
        } else {
            GeometryReader { geometry in
                VStack {
                    TabView {
                        ForEach(viewModel.timerCardViews.indices, id: \.self) { index in
                            VStack {
                                viewModel.timerCardViews[index]
                                    .environmentObject(self.viewModel) // 뷰 모델을 전달합니다.
                                    .frame(width: geometry.size.width - 40, height: geometry.size.height - 40)
                                    .onDrag {
                                        NSItemProvider(object: String(index) as NSString)
                                    }
                                    .onDrop(of: [UTType.text], delegate: viewModel.dropDelegate(for: index))
                            }
                        }
                        Button(action: {
                            isShowingSelectTimer.toggle()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(FancyColor.background.color)
                                    .frame(width: geometry.size.width - 40, height: geometry.size.height - 40)
                                    .shadow(color: Color(.systemGray).opacity(0.2), radius: 5, x: 0, y: 0)

                                LottieView(name: "lottie-plus")
                                    .frame(width: 128, height: 128)
                            }
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))

                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .navigationBarTitle("타임 타이머", displayMode: .inline)
                .navigationBarItems(
                    trailing: Button(action: { isShowingSelectTimer.toggle() }) {
                        Image(systemName: "plus")
                    }
                )
                .sheet(isPresented: $isShowingSelectTimer) {
                    SelectTimerView()
                        .environmentObject(self.viewModel) // 뷰 모델을 전달합니다.
                }
            }
        }
    }
}

struct TimeTimerView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: Container.shared.resolve(ContentViewModel.self))
            .environmentObject(Container.shared.resolve(TimeTimerViewModel.self))
    }
}
