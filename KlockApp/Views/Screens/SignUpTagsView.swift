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
        if let destination = viewModel.destination {
            switch destination {
            case .splash:
                SplashView(viewModel: SplashViewModel())
            default:
                EmptyView()
            }
        } else {
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
                               itemSpacing: 4) {
                        FancyButton(title: $0, action: {
                            debugPrint("태그 선택")
                        }, backgroundColor: Color.white, foregroundColor: FancyColor.primary.color, isBlock: false)
                    }.padding()
                    
                    FancyButton(title: "완료", action: {
                        viewModel.confirmButtonTapped.send()
                    }, backgroundColor: FancyColor.primary.color, foregroundColor: Color.white)
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
        SignUpTagsView(viewModel: SignUpTagsViewModel())
    }
}
