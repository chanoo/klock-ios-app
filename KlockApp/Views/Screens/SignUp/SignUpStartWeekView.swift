//
//  SignUpStartWeekView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/06/01.
//

import SwiftUI

struct SignUpStartWeekView: View {
    @EnvironmentObject var viewModel: SignUpViewModel
    @State private var selectedDay: FirstDayOfWeek = .sunday
    @State private var activeDestination: Destination?

    var body: some View {
        VStack {
            Image("img_signup_step2")
                .frame(maxWidth: .infinity, alignment: .topLeading)
            
            Text("한 주의 시작은\n언제인가요?")
                .font(.system(size: 25))
                .fontWeight(.bold)
                .padding(.top, 30)
                .lineSpacing(4)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            
            Text("사용할 플래너에 자동 적용되며, 언제든 변경 가능해요")
                .foregroundColor(.gray)
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.top, 1)
                .padding(.bottom, 30)

            HStack {
                FancyButton(
                    title: "일요일",
                    action: {
                        viewModel.setStartDay(day: .sunday)
                        selectedDay = .sunday
                    },
                    bordered: true,
                    style: .constant(selectedDay == .sunday ? .button : .outline)
                )
                FancyButton(
                    title: "월요일",
                    action: {
                        viewModel.setStartDay(day: .monday)
                        selectedDay = .monday
                    },
                    bordered: true,
                    style: .constant(selectedDay == .monday ? .button : .outline)
                )
            }
            
            Spacer()
            
            FancyButton(
                title: "다음",
                action: {
                    activeDestination = .signUpStartOfDay
                },
                disabled: !viewModel.isStartOfWeekNextButtonEnabled,
                style: .constant(.button)
            )
            
            NavigationLink(
                destination: viewForDestination(activeDestination),
                isActive: Binding<Bool>(
                    get: { activeDestination == .signUpStartOfDay },
                    set: { newValue in
                        if !newValue {
                            activeDestination = nil
                        }
                    }
                ),
                label: {
                    EmptyView()
                }
            )
            .hidden()
        }
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .padding(.all, 40)
    }
    
    private func viewForDestination(_ destination: Destination?) -> AnyView {
         switch destination {
         case .signUpStartOfDay:
             return AnyView(SignUpStartTimeView().environmentObject(viewModel))
         case .none, _:
             return AnyView(EmptyView())
         }
     }
}

struct SignUpStartWeekView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = Container.shared.resolve(SignUpViewModel.self)
        SignUpStartWeekView()
            .environmentObject(viewModel)
    }
}
