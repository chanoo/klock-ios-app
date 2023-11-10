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
    
    @StateObject private var timeTimerViewModel = Container.shared.resolve(TimeTimerViewModel.self)
    @StateObject private var calendarViewModel = Container.shared.resolve(CalendarViewModel.self)
    @StateObject private var chatBotViewModel = Container.shared.resolve(ChatBotViewModel.self)
    @StateObject private var taskViewModel = Container.shared.resolve(TaskViewModel.self)
    @StateObject private var characterViewModel = Container.shared.resolve(CharacterViewModel.self)
    @StateObject private var friendsViewModel = Container.shared.resolve(FriendsViewModel.self)
    @StateObject private var preferencesViewModel = Container.shared.resolve(PreferencesViewModel.self)

//    private func updateTitle(_ selection: Int) {
//        switch selection {
//        case 0:
//            title = "타이머"
//        case 1:
//            title = "Ai 선생님"
//        case 2:
//            title = "통계"
//        case 3:
//            title = "친구"
//        case 4:
//            title = "설정"
//        default:
//            title = ""
//        }
//    }

    var body: some View {
        FancyTabView(selection: $selection, items: [
            (
                selectedImageName: "ic_timer",
                deselectedImageName: "ic_timer",
                content: AnyView(
                    TimeTimerView()
                        .environmentObject(timeTimerViewModel)
                        .environmentObject(chatBotViewModel)
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
                selectedImageName: "ic_gear",
                deselectedImageName: "ic_gear_o",
                content: AnyView(
                    PreferencesView()
                        .environmentObject(preferencesViewModel)
                )
            ),
        ])
//        .onChange(of: selection) { newSelection in
//            updateTitle(newSelection)
//        }
//        .onAppear {
//            updateTitle(selection)
//        }
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
