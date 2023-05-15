//
//  SplashView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/08.
//

import SwiftUI

struct SplashView: View {
    @StateObject var viewModel: SplashViewModel = Container.shared.resolve(SplashViewModel.self)
    @EnvironmentObject var appFlowManager: AppFlowManager

    @ViewBuilder
    var destinationView: some View {
        HomeView()
    }

    var body: some View {
        ZStack {
            FancyColor.launchBackground.color.edgesIgnoringSafeArea(.all)

            VStack {
                Image("ic_klock_3dot")
                    .foregroundColor(FancyColor.launchSymbol.color)
                    .padding(.bottom, 32)

                Text("남과의 경쟁이 아닌")
                    .font(.system(size: 22))
                    .foregroundColor(FancyColor.launchSymbol.color)
                    .padding(.bottom, 2)

                Text("나의 성장을 위해")
                    .font(.system(size: 22))
                    .fontWeight(.bold)
                    .foregroundColor(FancyColor.launchSymbol.color)
            }
        }
        .onReceive(viewModel.$navigateToHome) { navigate in
            if navigate {
                appFlowManager.navigateToDestination.send(.home)
                viewModel.resetDestination()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.resetDestination()
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel: SplashViewModel = Container.shared.resolve(SplashViewModel.self)
        let manager = Container.shared.resolve(AppFlowManager.self)
        SplashView(viewModel: viewModel)
            .environmentObject(manager)
    }
}
