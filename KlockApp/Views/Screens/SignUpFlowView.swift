//
//  SignUpFlowView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/11.
//

import SwiftUI

struct SignUpFlowView: View {
    @EnvironmentObject private var appFlowManager: AppFlowManager

    var body: some View {
        NavigationView {
            SignUpUsernameView(viewModel: Container.shared.resolve(SignUpViewModel.self))
                .environmentObject(appFlowManager)
        }
    }
}

struct SignUpFlowView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpFlowView()
    }
}
