//
//  SelectTimerView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/21.
//

import SwiftUI

struct SelectTimerView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("타이머를 선택 하세요.")) {
                    NavigationLink(destination: StudyTimeTimerView()) {
                        Text("공부시간 타이머")
                    }
                    NavigationLink(destination: PomodoroTimerView()) {
                        Text("뽀모도로 타이머")
                    }
                    NavigationLink(destination: ExamTimeTimerView()) {
                        Text("시험시간 타이머")
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("타이머 추가")
            .navigationBarItems(trailing: Button("닫기") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct SelectTimerView_Previews: PreviewProvider {
    static var previews: some View {
        SelectTimerView()
    }
}
