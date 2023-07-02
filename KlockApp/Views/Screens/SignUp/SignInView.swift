import SwiftUI

struct SignInView: View {

    @EnvironmentObject var appFlowManager: AppFlowManager
    @EnvironmentObject var viewModel: SignInViewModel
    @State private var activeDestination: Destination?

    var body: some View {
        ZStack {
            Image("img_characters")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading) { // Add alignment here
                Text("평생 지켜질 공부습관\n평생 친구와 함께")
                    .foregroundColor(FancyColor.black.color)
                    .font(.system(size: 24, weight: .semibold))
                    .lineSpacing(6)
                    .padding(.top, 150)

                Image("ic_logo")
                    .padding(.top, 10)

                Spacer()

                FancyButton(
                    title: "애플로 시작하기",
                    action: {
                        viewModel.signInWithAppleTapped.send()
                    },
                    icon: Image("ic_apple"),
                    style: .constant(.apple)
                )
//
//                FancyButton(
//                    title: "카카오로 시작하기",
//                    action: {
//                        viewModel.signInWithAppleTapped.send()
//                    },
//                    icon: Image("ic_kakao"),
//                    style: .constant(.kakao)
//                )
//
//                FancyButton(
//                    title: "페이스북으로 시작하기",
//                    action: {
//                        viewModel.signInWithFacebookTapped.send()
//                    },
//                    icon: Image("ic_facebook"),
//                    style: .constant(.facebook)
//                )
            }
            .padding(.bottom, 40)
            .padding(40)
        }
        .onAppear {
            viewModel.onSignInWithFacebook = signInSuccessful
            viewModel.onSignUpProcess = signUpProcess
            viewModel.onSignInSuccess = signInSuccessful
        }
        .onReceive(viewModel.signInSuccess, perform: { _ in
            appFlowManager.navigateToDestination.send(.home)
        })
        .onReceive(viewModel.signUpProcess, perform: { _ in
            activeDestination = .signUpNickname
        })
        .background(
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
            .opacity(0)
        )
    }

    private func viewForDestination(_ destination: Destination?) -> AnyView {
        let signUpUserModel = viewModel.signUpUserModel
        switch destination {
        case .home:
            return AnyView(HomeView())
        case .signUpNickname:
            let viewModel = Container.shared.resolve(SignUpViewModel.self)
            viewModel.signUpUserModel = signUpUserModel
            return AnyView(SignUpNicknameView()
                .environmentObject(viewModel)
                .environmentObject(signUpUserModel))
        case .none, _:
            return AnyView(EmptyView())
        }
    }

    private func signUpProcess() {
        viewModel.signUpProcess.send()
    }

    private func signInSuccessful() {
        viewModel.signInSuccess.send()
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        
        let viewModel = Container.shared.resolve(SignInViewModel.self)
        SignInView()
            .environmentObject(viewModel)
    }
}
