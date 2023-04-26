//
//  HomeView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/02.
//

import SwiftUI

struct HomeView: View {
    @State private var selection = 0
    @State private var title: String = "홈"
    
    @ObservedObject private var timeTimerViewModel = Container.shared.resolve(TimeTimerViewModel.self)
    @ObservedObject private var calendarViewModel = Container.shared.resolve(CalendarViewModel.self)
    @ObservedObject private var chatBotViewModel = Container.shared.resolve(ChatBotViewModel.self)
    @ObservedObject private var taskViewModel = Container.shared.resolve(TaskViewModel.self)
    @ObservedObject private var characterViewModel = Container.shared.resolve(CharacterViewModel.self)

    private func updateTitle(_ selection: Int) {
        switch selection {
        case 0:
            title = "타이머"
        case 1:
            title = "통계"
        case 2:
            title = "Ai 선생님"
        case 3:
            title = "도전 과제"
        case 4:
            title = "캐릭터"
        default:
            title = ""
        }
    }

    var body: some View {
        FancyTabView(selection: $selection, items: [
            (imageName: "ic_clock", content: AnyView(
                TimeTimerView()
                    .environmentObject(timeTimerViewModel)
            )),
            (imageName: "ic_bar_graph", content: AnyView(
                CalendarView()
                    .environmentObject(calendarViewModel)
            )),
            (imageName: "ic_bachelor_cap", content: AnyView(
                ChatBotListView()
                    .environmentObject(chatBotViewModel)
            )),
            (imageName: "ic_arrow_target", content: AnyView(
                TaskListView()
                    .environmentObject(taskViewModel)
            )),
            (imageName: "ic_person", content: AnyView(
                CharacterView()
                    .environmentObject(characterViewModel)
            )),
        ])
        .navigationBarTitle(title, displayMode: .large)
        .onChange(of: selection) { newSelection in
            updateTitle(newSelection)
        }
        .onAppear {
            updateTitle(selection)
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(Container.shared.resolve(TimeTimerViewModel.self))
    }
}
