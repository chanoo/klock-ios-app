//
//  PomodoroTimerView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/21.
//

import SwiftUI
import Foast

struct PomodoroTimerView: View {
    @ObservedObject var model: PomodoroTimerModel
    @EnvironmentObject var viewModel: TimeTimerViewModel
    
    @State private var isFlipped: Bool = false
    
    private func flipAnimation() {
        withAnimation(.spring()) {
            isFlipped.toggle()
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
                        Text("공부")
                            .font(.headline)
                            .foregroundColor(.gray)
                        TextField("어떤 공부를 할건가요?", text: $model.name)
                    }

                    VStack(alignment: .leading) {
                        Text("공부 시간")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Stepper(value: $model.focusTime, in: 5...60, step: 5) {
                            Text("\(model.focusTime)분")
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("쉬는 시간")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Stepper(value: $model.restTime, in: 5...60, step: 5) {
                            Text("\(model.restTime)분")
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("반복 횟수")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Stepper(value: $model.cycleCount, in: 1...10) {
                            Text("\(model.cycleCount)회")
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
                            flipAnimation()
                            viewModel.delete(model: model)
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

//struct PomodoroTimerView_Previews: PreviewProvider {
//    static var previews: some View {
//        PomodoroTimerView()
//    }
//}
