//
//  SignUpProfileImageView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/06/05.
//

import SwiftUI

struct SignUpProfileImageView: View {
    @EnvironmentObject var viewModel: SignUpViewModel
    @State private var selectedDay: FirstDayOfWeek = .sunday
    @State private var activeDestination: Destination?

    var body: some View {
        VStack {
            Image("img_signup_step5")
                .frame(maxWidth: .infinity, alignment: .topLeading)
            
            Text("친구에게 보여주고픈\n나를 표현할 사진을 선택해요")
                .font(.system(size: 25))
                .fontWeight(.bold)
                .padding(.top, 30)
                .lineSpacing(4)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            
            Text("아직 고민된다면 언제든지 설정이 가능해요")
                .foregroundColor(.gray)
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.top, 1)
                .padding(.bottom, 30)


            ZStack {
                Button {
                    
                } label: {
                    Image("img_profile")
                }
                
                
                Button {
                    
                } label: {
                    Image("ic_plus")
                }
                .padding(.top, 110)
                .padding(.leading, 110)
            
            }
            .padding(.top, 50)

            Spacer()
            
            FancyButton(
                title: "시작하기",
                action: {
                    viewModel.confirmButtonTapped.send()
                },
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
//        .navigationBarItems(leading: BackButtonView())
        .navigationBarBackButtonHidden()
        .padding(.all, 30)
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

struct SignUpProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = Container.shared.resolve(SignUpViewModel.self)
        SignUpProfileImageView()
            .environmentObject(viewModel)
    }
}
