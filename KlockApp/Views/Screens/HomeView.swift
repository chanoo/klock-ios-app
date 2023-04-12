//
//  HomeView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/02.
//

import SwiftUI

struct HomeView: View {
    @State private var selection = 2

    var body: some View {
        TabView(selection: $selection) {
            StudyTimeView()
                .tabItem {
                    Label("공부 시간", systemImage: "clock")
                }
                .tag(0)

            ChatGPTView()
                .tabItem {
                    Label("챗봇", systemImage: "bubble.right")
                }
                .tag(1)

            StudyTimerView()
                .tabItem {
                    Label("타이머", systemImage: "timer")
                }
                .tag(2)

            FriendsView()
                .tabItem {
                    Label("친구 목록", systemImage: "person.2")
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
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
