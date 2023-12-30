//
//  PreferencesView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/07/04.
//

import SwiftUI

struct PreferencesView: View {
    @EnvironmentObject var viewModel: PreferencesViewModel
    @EnvironmentObject var actionSheetManager: ActionSheetManager
    @EnvironmentObject var myModel: MyModel
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
struct ProfileImageView: View {
    let imageURL: String?
    let size: CGFloat

    var body: some View {
        Group {
            if let urlString = imageURL, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty, .failure(_):
                        DefaultProfileImage()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .scaledToFit()
                            .clipShape(Circle())
                            .overlay(Circle().stroke(FancyColor.black.color, lineWidth: 4))
                    @unknown default:
                        DefaultProfileImage()
                    }
                }
            } else {
                DefaultProfileImage()
            }
        }
        .frame(width: size, height: size)
    }
}


struct DefaultProfileImage: View {
    var body: some View {
        Image("img_profile")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

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
        let model = MyModel.shared

        PreferencesView()
            .environmentObject(viewModel)
            .environmentObject(actionSheetManager)
            .environmentObject(model)
    }
}
