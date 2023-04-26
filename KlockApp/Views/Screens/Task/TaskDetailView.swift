//
//  TaskDetailView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/27.
//

import Foundation
import SwiftUI
import Combine

struct TaskDetailView: View {
    @State private var taskModel: TaskModel
    @State private var showAlert = false

    let dateFormatter: DateFormatter
    init(taskModel: TaskModel) {
        _taskModel = State(initialValue: taskModel)

        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }


    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(taskModel.title)
                    .font(.largeTitle)
                    .bold()

                Text(taskModel.description)
                    .font(.body)
                    .foregroundColor(.secondary)

                HStack {
                    Text("참여자")
                        .font(.headline)
                    Spacer()
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(taskModel.participants, id: \.self) { participant in
                            VStack {
                                Image(participant)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                                Text(participant)
                                    .font(.caption)
                            }
                        }
                    }
                }

                HStack {
                    Text("기간")
                        .font(.headline)
                    Spacer()
                }
                Text("\(taskModel.startDate, formatter: dateFormatter) - \(taskModel.endDate, formatter: dateFormatter)")
                    .font(.body)
                    .foregroundColor(.secondary)

                HStack {
                    Text("찌르기 횟수")
                        .font(.headline)
                    Spacer()
                }

                VStack(alignment: .leading) {
                    ForEach(taskModel.participants, id: \.self) { participant in
                        HStack {
                            Text(participant)
                            Spacer()
                            Text("\(taskModel.pokeCounts[participant] ?? 0) 회")
                        }
                    }
                }

                Button(action: {
                    // 찌르기 기능을 여기에 구현하세요.
                    self.pokeAllParticipants()
                    showAlert = true
                }) {
                    Text("찌르기")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top, 16)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("찌르기 성공"), message: Text("참여자들을 모두 찌르기했습니다."), dismissButton: .default(Text("확인")))
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func pokeAllParticipants() {
        for participant in taskModel.participants {
            taskModel.pokeCounts[participant, default: 0] += 1
        }
    }
}
