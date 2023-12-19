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
    @Environment(\.colorScheme) var colorScheme

    @ViewBuilder
    var destinationView: some View {
        HomeView()
    }

    var body: some View {
        ZStack {
            FancyColor.background.color.edgesIgnoringSafeArea(.all)

            VStack {
                ZStack(alignment: .center) {
                    if colorScheme == .dark {
                        LottieView(name: "lottie-loading-white", speed: 1.1)
                            .frame(width: 120, height: 120)
                    } else {
                        LottieView(name: "lottie-loading-black", speed: 1.1)
                            .frame(width: 120, height: 120)
                    }
                }
                .padding(.bottom, 32)

                if UserDefaults.standard.string(forKey: "access.token") != nil {
                    Text("남과의 경쟁이 아닌")
                        .font(.system(size: 22))
                        .foregroundColor(FancyColor.text.color)
                        .padding(.bottom, 2)
                    Text("나의 성장을 위해")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .foregroundColor(FancyColor.text.color)
                } else {
                    Text("나의 성장을 위해")
                        .font(.system(size: 22))
                        .foregroundColor(FancyColor.text.color)
                        .padding(.bottom, 2)
                    Text("또 만나요!")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .foregroundColor(FancyColor.text.color)
                }
            }
        }
        .onReceive(viewModel.$navigateToHome) { navigate in
            if navigate {
                if UserDefaults.standard.string(forKey: "access.token") != nil {
                    appFlowManager.navigateToDestination.send(.home)
                } else {
                    appFlowManager.navigateToDestination.send(.signIn)
                }
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
