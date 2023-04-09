//
//  StudyTagsView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/03.
//

import SwiftUI

struct SignUpTagsView: View {
    @StateObject var viewModel: SignUpTagsViewModel

    @ViewBuilder
    var destinationView: some View {
        switch viewModel.destination {
        case .splash:
            SplashView(viewModel: SplashViewModel())
        case .none, _:
            EmptyView()
        }
    }
    
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
                                viewModel.toggleTagSelection(id: tag.id!)
                            },
                            backgroundColor: viewModel.signUpUserModel.tagId == tag.id ? FancyColor.primary.color : Color.white,
                            foregroundColor: viewModel.signUpUserModel.tagId == tag.id ? Color.white : FancyColor.primary.color,
                            isBlock: false
                        )
                    }
                    
                    FancyButton(
                        title: "완료",
                        action: {
                            viewModel.confirmButtonTapped.send()
                        },
                        backgroundColor: FancyColor.primary.color,
                        foregroundColor: Color.white
                    )
                    .disabled(viewModel.selectedTagId == nil)
                    .opacity(viewModel.selectedTagId == nil ? 0.5 : 1)
                    .padding(.top, 30)
                    Spacer()
                }
                .padding()
            }
            NavigationLink(
                destination: destinationView,
                isActive: .constant(viewModel.destination != nil),
                label: {
                    EmptyView()
                }
            )
            .onAppear {
                viewModel.resetDestination()
            }
        }
        .background(FancyColor.background.color.edgesIgnoringSafeArea(.all))
        .modifier(CommonViewModifier(title: "태그 선택"))
        .navigationBarItems(leading: BackButtonView())
    }
}

struct SignUpTagsView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpTagsView(viewModel: SignUpTagsViewModel(signUpUserModel: SignUpUserModel()))
    }
}
