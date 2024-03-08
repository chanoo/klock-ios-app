//
//  PreferencesView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/07/04.
//

import SwiftUI

struct PreferencesView: View {
    @ObservedObject var viewModel: PreferencesViewModel
    @EnvironmentObject var actionSheetManager: ActionSheetManager
    @EnvironmentObject var appUsageController: AppUsageController
    @State private var isUserProfileImageViewPresented = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ProfileSection()
                SettingsSection()
            }
            .navigationBarTitle("설정", displayMode: .inline)
            .onAppear{
                viewModel.loadUserInfo()
            }
        }
        .familyActivityPicker(isPresented: $viewModel.isAppsSettingPresented,  selection: $appUsageController.selectionToDiscourage)
        .onChange(of: appUsageController.selectionToDiscourage) { newSelection in
            AppUsageController.shared.setShieldRestrictions()
        }
    }
}

// MARK: - Subviews
extension PreferencesView {
    private func ProfileSection() -> some View {
        HStack {
            ProfileImageView(imageURL: viewModel.profileImage, size: 66)
            Text(viewModel.nickname)
            Spacer()
            EditProfileLink()
        }
        .padding()
    }

    private func SettingsSection() -> some View {
        LazyVStack(spacing: 0) {
            ForEach(viewModel.preferencesSections, id: \.self.id) { section in
                SectionItems(section: section)
                Spacer().frame(height: 30)
            }
        }
    }
}

// MARK: - Helper Views

struct EditProfileLink: View {
    @EnvironmentObject var viewModel: PreferencesViewModel
    @EnvironmentObject var actionSheetManager: ActionSheetManager
    @State private var isUserProfileImageViewPresented = false

    var body: some View {
        NavigationLink(
            destination: UserProfileImageView()
                .environmentObject(viewModel)
                .environmentObject(actionSheetManager),
            isActive: $isUserProfileImageViewPresented
        ) {
            EditButtonContent()
        }
        .onAppear { isUserProfileImageViewPresented = false }
    }
}

struct EditButtonContent: View {
    var body: some View {
        HStack {
            Image("ic_pencil_line").foregroundColor(FancyColor.black.color)
            Text("편집")
                .font(.system(size: 12, weight: .semibold))
                .lineSpacing(18)
                .foregroundColor(FancyColor.black.color)
        }
        .padding([.top, .bottom], 8)
        .padding([.leading, .trailing], 16)
        .background(Color(red: 0.93, green: 0.94, blue: 0.96))
        .cornerRadius(15)
    }
}

struct SectionItems: View {
    @EnvironmentObject var viewModel: PreferencesViewModel
    @EnvironmentObject var actionSheetManager: ActionSheetManager
    var section: SectionModel

    var body: some View {
        ForEach(section.items, id: \.self.id) { item in
            if let destination = item.destinationView {
                NavigationLink(
                    destination: destination
                        .environmentObject(viewModel)
                        .environmentObject(actionSheetManager)
                ) {
                    ItemView(item: item)
                }
            } else {
                Button(action: item.action ?? {}) {
                    ItemView(item: item)
                }
            }
            Divider().padding([.leading, .trailing], 16)
        }
    }
}

struct ItemView: View {
    let item: ItemModel

    var body: some View {
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

// Models
struct SectionModel: Identifiable {
    var id = UUID()
    var items: [ItemModel]
}

struct ItemModel: Identifiable {
    var id = UUID()
    var title: String
    var iconName: String?
    var systemIconName: String?
    var actionType: ActionType
    var destinationView: AnyView?
    var action: (() -> Void)?
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = Container.shared.resolve(PreferencesViewModel.self)
        let actionSheetManager = ActionSheetManager()
        let appUsageController = AppUsageController.shared

        PreferencesView(viewModel: viewModel)
            .environmentObject(actionSheetManager)
            .environmentObject(appUsageController)
    }
}
