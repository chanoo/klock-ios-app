//
//  HomeView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/02.
//

import SwiftUI

struct HomeView: View {
    @State private var selection = 2
    @State private var title: String = "홈"

    private func updateTitle(_ selection: Int) {
        switch selection {
        case 0:
            title = "공부 시간"
        case 1:
            title = "Ai 선생님"
        case 2:
            title = "타이머"
        case 3:
            title = "친구"
        case 4:
            title = "미션"
        case 5:
            title = "캐릭터"
        case 6:
            title = "설정"
        default:
            title = "홈"
        }
    }

    var body: some View {
        TabView(selection: $selection) {
            CalendarView()
                .tabItem {
                    Label("공부 시간", systemImage: "clock")
                }
                .tag(0)

            ChatBotListView()
                .tabItem {
                    Label("Ai 선생님", systemImage: "bubble.right")
                }
                .tag(1)

            StudyTimerView()
                .tabItem {
                    Label("타이머", systemImage: "timer")
                }
                .tag(2)

            FriendsView()
                .tabItem {
                    Label("친구", systemImage: "person.2")
                }
                .tag(3)

            MissionView()
                .tabItem {
                    Label("미션", systemImage: "checkmark.square")
                }
                .tag(4)

            CharacterView()
                .tabItem {
                    Label("캐릭터", systemImage: "person")
                }
                .tag(5)

            SettingsView()
                .tabItem {
                    Label("설정", systemImage: "gear")
                }
                .tag(6)
        }
        .navigationBarTitle(title)
        .background(FancyColor.primary.color)
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
        ContentView(viewModel: ContentViewModel())
    }
}
