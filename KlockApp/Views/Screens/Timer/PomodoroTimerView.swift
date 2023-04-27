//
//  PomodoroTimerView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/21.
//

import SwiftUI
import Foast

struct PomodoroTimerView: View {
    @State private var isFlipped: Bool = false
    @State private var workTime: Int = 25
    @State private var breakTime: Int = 5
    @State private var repeatCount: Int = 4

    init() {
        if #unavailable(iOS 16.0) {
            print("### setting backgroundColor to .clear")
            UITableView.appearance().backgroundColor = .clear
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            frontView(geometry: geometry)
                .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0.0, y: 1.0, z: 0.0))
                .opacity(isFlipped ? 0 : 1)
            
            backView(geometry: geometry)
                .rotation3DEffect(.degrees(isFlipped ? 0 : 180), axis: (x: 0.0, y: 1.0, z: 0.0))
                .opacity(isFlipped ? 1 : 0)
        }
        .background(FancyColor.background.color)
        .cornerRadius(10)
        .shadow(color: Color(.systemGray).opacity(0.2), radius: 5, x: 0, y: 0)
    }
    
    private func frontView(geometry: GeometryProxy) -> some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    withAnimation(.spring()) {
                        isFlipped.toggle()
                    }
                }) {
                    Image(systemName: "gearshape")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(24)
                }
            }
            Spacer()
            Text("뽀모도로 타이머")
            Spacer()
        }
    }
    
    private func backView(geometry: GeometryProxy) -> some View {
        VStack {
            List {
                Section(header: Text("뽀모도로 설정")) {
                    VStack(alignment: .leading) {
                        Text("공부 시간")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Stepper(value: $workTime, in: 5...60, step: 5) {
                            Text("\(workTime)분")
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("쉬는 시간")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Stepper(value: $breakTime, in: 5...60, step: 5) {
                            Text("\(breakTime)분")
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("반복 횟수")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Stepper(value: $repeatCount, in: 1...10) {
                            Text("\(repeatCount)회")
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        // Save settings
                        withAnimation(.spring()) {
                            isFlipped.toggle()
                        }
                    }) {
                        Text("저장")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                
                Section {
                    Button(action: {
                        withAnimation(.spring()) {
                            isFlipped.toggle()
                        }
                    }) {
                        Text("취소")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                
                Section {
                    Button(action: {
                        withAnimation(.spring()) {
                            isFlipped.toggle()
                            Foast.show(message: "삭제 되었습니다.")
                        }
                    }) {
                        Text("삭제")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(FancyColor.secondary.color)
                    }
                }
            }
    //                .listStyle(GroupedListStyle())
            .clearListBackground()
        }
    }
}

struct PomodoroTimerView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroTimerView()
    }
}
