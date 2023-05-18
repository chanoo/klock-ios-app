//
//  ExamTimerCardView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/05/18.
//

import SwiftUI
import Foast

struct ExamTimerCardView: View {

    @EnvironmentObject var examTimerViewModel: ExamTimerViewModel
    @EnvironmentObject var timeTimerViewModel: TimeTimerViewModel
    @EnvironmentObject var tabBarManager: TabBarManager
    
    @State private var isFlipped: Bool = false
    
    private func flipAnimation() {
        withAnimation(.spring()) {
            isFlipped.toggle()
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
                Text("시험시간 타이머")
                Spacer()
            }
            .background(FancyColor.background.color)
            .cornerRadius(10)
            .shadow(color: Color(.systemGray).opacity(0.2), radius: 5, x: 0, y: 0)
            .rotation3DEffect(
                .degrees(isFlipped ? 180 : 0),
                axis: (x: 0.0, y: 1.0, z: 0.0)
            )
            .opacity(isFlipped ? 0 : 1)

            // Back view (settings)
            VStack {
                List {
                    Section(header: Text("시험시간 설정")) {
                        
                        VStack(alignment: .leading) {
                            Text("시험명")
                                .font(.headline)
                                .foregroundColor(.gray)
                            TextField("시험명을 입력해요.", text: $examTimerViewModel.model.name)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("시험 시간")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Stepper(value: $examTimerViewModel.model.duration, in: 5...240, step: 1) {
                                Text("\(examTimerViewModel.model.duration)분")
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("마킹 시간")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Stepper(value: $examTimerViewModel.model.markingTime, in: 0...60, step: 1) {
                                Text("\(examTimerViewModel.model.markingTime)분")
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("시험 문항수")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Stepper(value: $examTimerViewModel.model.questionCount, in: 1...120) {
                                Text("\(examTimerViewModel.model.questionCount)개")
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
                    }.padding(0)

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
            .background(FancyColor.background.color)
            .cornerRadius(10)
            .shadow(color: Color(.systemGray).opacity(0.2), radius: 5, x: 0, y: 0)
            .rotation3DEffect(
                .degrees(isFlipped ? 0 : 180),
                axis: (x: 0.0, y: 1.0, z: 0.0)
            )
            .opacity(isFlipped ? 1 : 0)
        }
    }
}

//struct ExamTimeTimerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExamTimeTimerView(model: <#T##ExamTimerModel#>)
//    }
//}
