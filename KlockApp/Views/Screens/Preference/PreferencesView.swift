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

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                // Profile
                HStack {
                    Image(viewModel.profileImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 66, height: 66)
                    Text(viewModel.profileName)
                    Spacer()
                    Button(action: { viewModel.editProfile() }) {
                        Image(systemName: "pencil")
                    }
                }
                .padding()

                // Settings
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.preferencesSections, id: \.self.id) { section in
                        ForEach(section.items, id: \.self.id) { item in
                            Group {
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
                            }
                            Divider()
                                .padding([.leading, .trailing], 16)
                        }
                        Spacer()
                            .frame(height: 30)
                    }
                }
            }
            .familyActivityPicker(isPresented: $viewModel.isAppsSettingPresented,  selection: $myModel.selectionToDiscourage)
            .onChange(of: myModel.selectionToDiscourage) { newSelection in
                MyModel.shared.setShieldRestrictions()
            }

        }
        .navigationBarTitle("설정", displayMode: .inline)
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
        PreferencesView()
            .environmentObject(viewModel)
    }
}
