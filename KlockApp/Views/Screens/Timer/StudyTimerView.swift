//
//  StudyTimerView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/12.
//

import SwiftUI
import UniformTypeIdentifiers
import Lottie

struct StudyTimerView: View {
    @StateObject private var viewModel: ClockViewModel = Container.shared.resolve(ClockViewModel.self)
    @State private var isShowingSelectTimer = false
    @State private var timerCardViews: [AnyView] = [
        AnyView(StudyTimeTimerView()),
        AnyView(PomodoroTimerView()),
        AnyView(ExamTimeTimerView()),
        AnyView(PomodoroTimerView())
    ]

    var body: some View {
        GeometryReader { geometry in
            VStack {
                TabView {
                    ForEach(0 ..< timerCardViews.count, id: \.self) { index in
                        VStack {
                            timerCardViews[index]
                                .frame(width: geometry.size.width - 40, height: geometry.size.height - 40)
                                .onDrag {
                                    NSItemProvider(object: String(index) as NSString)
                                }
                                .onDrop(of: [UTType.text], delegate: TimerDropDelegate(index: index, timerCardViews: $timerCardViews))
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
//                .indexViewStyle(.page(backgroundDisplayMode: .never))
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

struct TimerDropDelegate: DropDelegate {
    let index: Int
    @Binding var timerCardViews: [AnyView]
    
    func performDrop(info: DropInfo) -> Bool {
        if let source = info.itemProviders(for: [.text]).first {
            source.loadItem(forTypeIdentifier: UTType.text.identifier, options: nil) { (data, error) in
                if let data = data as? Data, let sourceIndex = Int(String(data: data, encoding: .utf8) ?? "") {
                    DispatchQueue.main.async {
                        let sourceView = timerCardViews.remove(at: sourceIndex)
                        timerCardViews.insert(sourceView, at: index)
                    }
                }
            }
            return true
        }
        return false
    }
}

struct StudyTimerView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: Container.shared.resolve(ContentViewModel.self))
    }
}
