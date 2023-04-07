//
//  StudyTagsView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/03.
//

import SwiftUI

struct SignUpTagsView: View {
    @StateObject var viewModel: SignUpTagsViewModel

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
                        debugPrint("완료")
                    }, backgroundColor: FancyColor.primary.color, foregroundColor: Color.white)
                    .padding(.top, 30)
                    Spacer()
                }
                .padding()
            }
        }
        .background(FancyColor.background.color.edgesIgnoringSafeArea(.all))
        .navigationBarTitle("태그 선택", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .onAppear {
            AppState.shared.swipeEnabled = false
        }
        .onDisappear {
            AppState.shared.swipeEnabled = true
        }
    }
    
    var backButton: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(FancyColor.primary.color) // 색상을 원하는대로 변경
                Text("")
            }
        }
    }
}

struct SignUpTagsView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpTagsView(viewModel: SignUpTagsViewModel())
    }
}
