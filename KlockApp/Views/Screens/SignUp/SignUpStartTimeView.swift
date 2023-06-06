//
//  SignUpStartTimeView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/06/01.
//

import SwiftUI

struct SignUpStartTimeView: View {
    @EnvironmentObject var viewModel: SignUpViewModel
    @State private var activeDestination: Destination?
    @State private var showPicker = false
    @State private var selectedHour = 0
    let hours = Array(0..<24) // Array of hours

    var body: some View {
        VStack {
            HStack {
                Image("img_signup_step3")
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            
            HStack {
                Text("하루의 시작은\n언제인가요?")
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                    .padding(.top, 30)
                    .lineSpacing(4)
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            
            Text("사용할 플래너에 자동 적용되며, 언제든 변경 가능해요")
                .foregroundColor(.gray)
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.top, 1)
                .padding(.bottom, 30)

            VStack {
                Button(action: {
                    showPicker = true
                }) {
                    Text("\(viewModel.signUpUserModel.startTime)시")
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
                .actionSheet(isPresented: $showPicker) {
                    ActionSheet(title: Text("하루의 시작 시간을 선택하세요."), buttons: hourButtons())
                }
            }
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.black)

            Text(viewModel.error ?? "")
                .foregroundColor(.gray)
                .padding(.bottom, 30)
                .frame(maxWidth: .infinity, alignment: .topLeading)

            Spacer()
            
            FancyButton(
                title: "다음",
                action: {
                    activeDestination = .signUpTags
                },
                disabled: .constant(!viewModel.isStartOfWeekNextButtonEnabled),
                style: .constant(.button)
            )

            NavigationLink(
                destination: viewForDestination(activeDestination),
                isActive: Binding<Bool>(
                    get: { activeDestination == .signUpTags },
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
        // 왼쪽 정렬
        .frame(maxHeight: .infinity, alignment: .topLeading)
//        .navigationBarItems(leading: BackButtonView())ㄴ
        .navigationBarBackButtonHidden()
        .padding(.all, 30)
    }
    
    func hourButtons() -> [ActionSheet.Button] {
        var buttons = hours.map { hour in
            Alert.Button.default(Text("\(hour)시")) {
                viewModel.signUpUserModel.startTime = hour
            }
        }
        buttons.append(.cancel())
        return buttons
    }
    
    private func viewForDestination(_ destination: Destination?) -> AnyView {
         switch destination {
         case .signUpTags:
             return AnyView(SignUpTagView().environmentObject(viewModel))
         case .none, _:
             return AnyView(EmptyView())
         }
     }
}

struct SignUpStartTimeView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = Container.shared.resolve(SignUpViewModel.self)
        SignUpStartTimeView()
            .environmentObject(viewModel)
    }
}
