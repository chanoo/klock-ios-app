//
//  PomodoroTimerView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/21.
//

import SwiftUI

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
        ZStack {
            // Front view
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
            .background(FancyColor.background.color)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 0)
            .rotation3DEffect(
                .degrees(isFlipped ? 180 : 0),
                axis: (x: 0.0, y: 1.0, z: 0.0)
            )
            .opacity(isFlipped ? 0 : 1)

            // Back view (settings)
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
                }
//                .listStyle(GroupedListStyle())
                .clearListBackground()
            }
            .background(FancyColor.background.color)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 0)
            .rotation3DEffect(
                .degrees(isFlipped ? 0 : 180),
                axis: (x: 0.0, y: 1.0, z: 0.0)
            )
            .opacity(isFlipped ? 1 : 0)
        }
    }
}

struct ClearListBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.scrollContentBackground(.hidden)
        } else {
            content
        }
    }
}

extension View {
    func clearListBackground() -> some View {
        modifier(ClearListBackgroundModifier())
    }
}

struct PomodoroTimerView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroTimerView()
    }
}
