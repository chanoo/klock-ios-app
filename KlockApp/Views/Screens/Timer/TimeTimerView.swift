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
    @StateObject private var viewModel = Container.shared.resolve(TimeTimerViewModel.self)
    @State private var isShowingSelectTimer = false

    var body: some View {
        GeometryReader { geometry in
            VStack {
                TabView {
                    ForEach(viewModel.timerCardViews.indices, id: \.self) { index in
                        VStack {
                            viewModel.timerCardViews[index]
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
                            RoundedRectangle(cornerRadius: 8)
                                .fill(FancyColor.background.color)
                                .frame(width: geometry.size.width - 40, height: geometry.size.height - 40)
                                .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 0)
                            
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
            }
        }
    }
}

struct StudyTimerView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: Container.shared.resolve(ContentViewModel.self))
    }
}
