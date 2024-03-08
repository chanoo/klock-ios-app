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
    
    @StateObject private var tabBarManager = Container.shared.resolve(TabBarManager.self)
    @StateObject private var preferencesViewModel = Container.shared.resolve(PreferencesViewModel.self)

    var body: some View {
        FancyTabView(selection: $selection, items: [
            (
                selectedImageName: "ic_timer",
                deselectedImageName: "ic_timer",
                content: {
                    AnyView(
                        TimeTimerView()
                            .environmentObject(tabBarManager)
                    )
                }
            ),
            (
                selectedImageName: "ic_balloon",
                deselectedImageName: "ic_balloon",
                content: {
                    AnyView(
                       ChatBotListView()
                   )
                }
            ),
            (
                selectedImageName: "ic_graph_bar",
                deselectedImageName: "ic_graph_bar",
                content: {
                    AnyView(
                        CalendarView()
                    )
                }
            ),
            (
                selectedImageName: "ic_peaple",
                deselectedImageName: "ic_peaple_o",
                content: {
                    AnyView(
                        MyWallView()
                            .environmentObject(tabBarManager)
                    )
                }
            ),
            (
                selectedImageName: "ic_tame",
                deselectedImageName: "ic_tame_o",
                content: {
                    AnyView(
                        PreferencesView(viewModel: preferencesViewModel)
                    )
                }
            ),
        ])
        .environmentObject(tabBarManager)
        .background(FancyColor.background.color)
    }
}
