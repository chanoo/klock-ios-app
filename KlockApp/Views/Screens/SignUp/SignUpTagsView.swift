//
//  StudyTagsView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/03.
//

import SwiftUI

struct SignUpTagsView: View {

    @EnvironmentObject var viewModel: SignUpViewModel
    @EnvironmentObject var signUpUserModel: SignUpUserModel
    @State private var activeDestination: Destination?

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    Text("나를 설명할 수 있는 단어를 골라보세요!")
                        .font(.system(size: 18))
                        .foregroundColor(Color.black)
                        .fontWeight(.bold)
                        .padding(.top, 32)
                        .padding(.bottom, 32)

                    FlowLayout(mode: .scrollable,
                               items: viewModel.tags,
                               itemSpacing: 4) { tag in
                        FancyButton(
                            title: tag.name,
                            action: {
                                viewModel.toggleTagSelectionSubject.send(tag.id!)
                            },
                            style: .constant(.secondary)
                        )
                    }

                    FancyButton(
                        title: "완료",
                        action: {
                            viewModel.confirmButtonTapped.send()
                        },
                        style: .constant(.primary)
                    )
                    .disabled(viewModel.selectedTagId == nil)
                    .opacity(viewModel.selectedTagId == nil ? 0.5 : 1)
                    .padding(.top, 30)
                    Spacer()
                }
                .padding()
            }
        }
        .background(FancyColor.background.color.edgesIgnoringSafeArea(.all))
        .modifier(CommonViewModifier(title: "태그 선택"))
        .navigationBarItems(leading: BackButtonView())
        .onAppear {
            viewModel.fetchTagsSubject.send()
            viewModel.onSignUpSuccess = signUpSuccess
        }
        .onReceive(viewModel.signUpSuccess, perform: { _ in
            activeDestination = .splash
        })
        .background(
            NavigationLink(
                destination: viewForDestination(activeDestination),
                isActive: Binding<Bool>(
                    get: { activeDestination != nil },
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
            .opacity(0)
        )
    }
    
    private func viewForDestination(_ destination: Destination?) -> AnyView {
        switch destination {
        case .splash:
            return AnyView(SplashView())
        case .none, _:
            return AnyView(EmptyView())
        }
    }

    private func signUpSuccess() {
        viewModel.signUpSuccess.send()
    }
}

struct SignUpTagsView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = Container.shared.resolve(SignUpViewModel.self)
        SignUpTagsView()
            .environmentObject(viewModel)
            .environmentObject(AppFlowManager())
    }
}
