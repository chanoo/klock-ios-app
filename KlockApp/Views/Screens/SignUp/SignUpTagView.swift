//
//  SignUpTagView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/06/02.
//

import SwiftUI

struct SignUpTagView: View {
    @EnvironmentObject var viewModel: SignUpViewModel
    @State private var activeDestination: Destination?

    let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Image("img_signup_step4")
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                
                HStack {
                    Text("왜 스터디 습관이\n필요하신가요?")
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .padding(.top, 30)
                        .lineSpacing(4)
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                
                Text("친구추천과 게시물 큐레이션에 활용해요")
                    .foregroundColor(.gray)
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.top, 1)
                    .padding(.bottom, 30)
                
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(viewModel.tags, id: \.self.id) { tag in
                        FancyButton(
                            title: tag.name,
                            action: {
                                viewModel.toggleTagSelectionSubject.send(tag.id!)
                            },
                            bordered: true,
                            style: .constant(viewModel.selectedTagId == tag.id ? .button : .outline)
                        )
                    }
                }

                Text(viewModel.error ?? "")
                    .foregroundColor(.gray)
                    .padding(.bottom, 30)
                    .frame(maxWidth: .infinity, alignment: .topLeading)

                FancyButton(
                    title: "다음",
                    action: {
                        activeDestination = .signUpProfileImage
                    },
                    disabled: Binding<Bool?>(
                        get: { !self.viewModel.isTagNextButtonEnabled },
                        set: { self.viewModel.isTagNextButtonEnabled = !($0 ?? false) }
                    ),
                    style: .constant(.button)
                )
            }
            .navigationBarBackButtonHidden()
            .padding(.all, 30)
            .onChange(of: viewModel.signUpUserModel.tagId > 0) { newValue in
                viewModel.isTagNextButtonEnabled = newValue
            }

            NavigationLink(
                destination: viewForDestination(activeDestination),
                isActive: Binding<Bool>(
                    get: { activeDestination == .signUpProfileImage },
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
        .onAppear {
            viewModel.fetchTagsSubject.send()
        }
    }

    private func viewForDestination(_ destination: Destination?) -> AnyView {
         switch destination {
         case .signUpProfileImage:
             return AnyView(SignUpProfileImageView().environmentObject(viewModel))
         case .none, _:
             return AnyView(EmptyView())
         }
     }
}

struct SignUpTagView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = Container.shared.resolve(SignUpViewModel.self)
        SignUpTagView()
            .environmentObject(viewModel)
    }
}
