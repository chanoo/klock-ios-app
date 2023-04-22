//
//  ExamTimeTimerView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/21.
//

import SwiftUI

struct ExamTimeTimerView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.spring()) {
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
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(FancyColor.background.color)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 0)        }
        
    }
}

struct ExamTimeTimerView_Previews: PreviewProvider {
    static var previews: some View {
        ExamTimeTimerView()
    }
}
