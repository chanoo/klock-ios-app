//
//  StudyTimerView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/12.
//

import SwiftUI

struct StudyTimerView: View {
    @StateObject private var viewModel: ClockViewModel = Container.shared.resolve(ClockViewModel.self)
    @State private var isShowingSelectTimer = false
    @State private var timerCardViews: [AnyView] = [
        AnyView(StudyTimeTimerView()),
        AnyView(PomodoroTimerView()),
        AnyView(ExamTimeTimerView())
    ]

    var body: some View {
        GeometryReader { geometry in
            VStack {
                TabView {
                    ForEach(0 ..< timerCardViews.count, id: \.self) { index in
                        timerCardViews[index]
                            .frame(width: geometry.size.width - 32, height: geometry.size.height - 32)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 4)
                    }
                    Button(action: {
                        isShowingSelectTimer.toggle()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .frame(width: geometry.size.width - 32, height: geometry.size.height - 32)
                                .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 4)
                            
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(FancyColor.primary.color)
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
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
