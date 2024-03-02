//
//  AccountSecurityView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/07/05.
//

import SwiftUI

struct AccountSecurityView: View {
    @EnvironmentObject var viewModel: PreferencesViewModel
    @EnvironmentObject var actionSheetManager: ActionSheetManager
    @State private var activeDestination: Destination?

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                // 계정 및 보안
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.accountSecuritySections, id: \.self.id) { section in
                        ForEach(section.items, id: \.self.id) { item in
                            Group {
                                AccountSecurityItemView(item: item, action: {
                                    switch item.actionType {
                                    case .logout:
                                        // 로그아웃 액션 설정
                                        logoutActionSheet()
                                    case .deleteAccount:
                                        // 회원 탈퇴 액션 설정
                                        deleteAccountActionSheet()
                                    default:
                                        // 다른 경우에 대한 액션 설정
                                        print("No action associated")
                                    }
                                })
                            }
                            Divider()
                                .padding([.leading, .trailing], 16)
                        }
                        Spacer()
                            .frame(height: 30)
                    }
                }
            }
            
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
            .hidden()
        }
        .navigationBarTitle("계정 및 보안", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: BackButtonView()
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
    
    private func deleteAccountActionSheet() {
        actionSheetManager.actionSheet = CustomActionSheetView(
            title: "회원 탈퇴",
            message: "데이터는 즉시 영구삭제되며 복구할 수 없습니다.",
            actionButtons: [
                FancyButton(title: "회원탈퇴", action: {
                    viewModel.deleteAccountButtonTapped.send()
                    actionSheetManager.isPresented = false
                    activeDestination = .splash
                }, style: .constant(.outline)),
            ],
            cancelButton: FancyButton(title: "취소", action: {
                actionSheetManager.isPresented = false
            }, style: .constant(.text))
        )
        withAnimation(.spring()) {
            actionSheetManager.isPresented = true
        }
    }
    
    private func logoutActionSheet() {
        actionSheetManager.actionSheet = CustomActionSheetView(
            title: "로그아웃",
            message: "정말로 로그아웃하시겠습니까?",
            content: nil,
            actionButtons: [
                FancyButton(title: "로그아웃", action: {
                    viewModel.logoutButtonTapped.send()
                    actionSheetManager.isPresented = false
                    activeDestination = .splash
                }, style: .constant(.outline)),
            ],
            cancelButton: FancyButton(title: "취소", action: {
                actionSheetManager.isPresented = false
            }, style: .constant(.text))
        )
        withAnimation(.spring()) {
            actionSheetManager.isPresented = true
        }
    }
}

struct AccountSecurityItemView: View {
    let item: ItemModel
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 0) {
                if let iconName = item.iconName {
                    Image(iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .padding([.trailing], 12)
                }
                if let systemIconName = item.systemIconName {
                    Image(systemName: systemIconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .padding([.trailing], 12)
                }
                Text(item.title)
                    .font(.system(size: 15))
                Spacer()
                Image("ic_chevron_right")
            }
            .padding(20)
        }
    }
}

struct AccountSecurityView_Previews: PreviewProvider {
    static var previews: some View {
        AccountSecurityView()
    }
}
