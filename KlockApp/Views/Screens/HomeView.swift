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

    private func updateTitle(_ selection: Int) {
        switch selection {
        case 0:
            title = "타이머"
        case 1:
            title = "통계"
        case 2:
            title = "Ai 선생님"
        case 3:
            title = "캐릭터"
        default:
            title = ""
        }
    }

    var body: some View {
        FancyTabView(selection: $selection, imageNames: [
            "ic_clock",
            "ic_bar_graph",
            "ic_bachelor_cap",
            "ic_person"
        ]) {
            if selection == 0 {
                StudyTimerView()
            } else if selection == 1 {
                CalendarView()
            } else if selection == 2 {
                ChatBotListView()
            } else if selection == 3 {
                FriendsView()
            }
        }
        .navigationBarTitle(title)
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
    }
}
