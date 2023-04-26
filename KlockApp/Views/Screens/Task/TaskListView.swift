//
//  TaskView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/26.
//

import SwiftUI

struct TaskListView: View {
    
    @EnvironmentObject var viewModel: TaskViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(viewModel.tasks) { taskModel in
                    TaskRowView(taskModel: taskModel)
                }
            }
            .padding()
        }
    }
}

struct TaskRowView: View {
    var taskModel: TaskModel

    var body: some View {
        NavigationLink(destination: TaskDetailView(taskModel: taskModel)) {
            HStack {
                VStack(alignment: .leading) {
                    Text(taskModel.title)
                        .font(.headline)
                    HStack(spacing: -10) {
                        ForEach(taskModel.participants, id: \.self) { participant in
                            Image(participant)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                )
                        }
                    }
                }

                Spacer()

                CircleProgressView(progress: taskModel.progress)
                    .frame(width: 50, height: 50)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(color: Color(.systemGray).opacity(0.2), radius: 5, x: 0, y: 0)
    }
}

struct CircleProgressView: View {
    var progress: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 4)
                .opacity(0.1)
                .foregroundColor(Color(.systemGray4))

            Circle()
                .trim(from: 0.0, to: CGFloat(progress))
                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                .foregroundColor(FancyColor.secondary.color)
                .rotationEffect(Angle(degrees: 270))
                .animation(.linear, value: progress)

            Text("\(Int(progress * 100))%")
                .font(.caption)
                .bold()
        }
    }
}
