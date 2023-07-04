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
    @ObservedObject private var friendsViewModel = Container.shared.resolve(FriendsViewModel.self)

    private func updateTitle(_ selection: Int) {
        switch selection {
        case 0:
            title = "타이머"
        case 1:
            title = "Ai 선생님"
        case 2:
            title = "통계"
        case 3:
            title = "친구"
        case 4:
            title = "설정"
        default:
            title = ""
        }
    }

    var body: some View {
        FancyTabView(selection: $selection, items: [
            (
                selectedImageName: "ic_timer",
                deselectedImageName: "ic_timer",
                content: AnyView(
                    TimeTimerView()
                        .environmentObject(timeTimerViewModel)
                )
            ),
            (
                selectedImageName: "ic_balloon",
                deselectedImageName: "ic_balloon",
                content: AnyView(
                    ChatBotListView()
                        .environmentObject(chatBotViewModel)
                )
            ),
            (
                selectedImageName: "ic_graph_bar",
                deselectedImageName: "ic_graph_bar",
                content: AnyView(
                    CalendarView()
                        .environmentObject(calendarViewModel)
                )
            ),
            (
                selectedImageName: "ic_peaple",
                deselectedImageName: "ic_peaple_o",
                content: AnyView(
                    FriendsView()
                        .environmentObject(friendsViewModel)
                )
            ),
            (
                selectedImageName: "ic_gear_o",
                deselectedImageName: "ic_gear_o",
                content: AnyView(
                    TaskListView()
                        .environmentObject(taskViewModel)
                )
            ),
        ])
        .onChange(of: selection) { newSelection in
            updateTitle(newSelection)
        }
        .onAppear {
            updateTitle(selection)
        }
        .background(FancyColor.background.color)
    }
}

//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//            .environmentObject(Container.shared.resolve(TimeTimerViewModel.self))
//    }
//}
