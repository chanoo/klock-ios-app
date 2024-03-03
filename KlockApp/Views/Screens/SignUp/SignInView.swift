import SwiftUI

struct SignInView: View {

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
                    .foregroundColor(FancyColor.text.color)
                    .font(.system(size: 24, weight: .semibold))
                    .lineSpacing(6)
                    .padding(.top, 150)

                Image("ic_logo_klock")
                    .foregroundColor(FancyColor.text.color)
                    .padding(.top, 10)

                Spacer()

                FancyButton(
                    title: "Apple로 로그인",
                    action: {
                        viewModel.signInWithAppleTapped.send()
                    },
                    icon: Image("ic_apple"),
                    style: .constant(.apple)
                )
                .padding(.bottom, 12)

                FancyButton(
                    title: "카카오로 로그인",
                    action: {
                        viewModel.signInWithKakaoTapped.send()
                    },
                    icon: Image("ic_kakao"),
                    style: .constant(.kakao)
                )
                .padding(.bottom, 24)

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
            }
            .padding(.bottom, 40)
            .padding(40)
            
            if viewModel.isSigning {
                LoadingView(opacity: 0.7)
            }
        }
        .onAppear {
            viewModel.onSignInWithFacebook = signInSuccessful
            viewModel.onSignUpProcess = signUpProcess
            viewModel.onSignInSuccess = signInSuccessful
        }
        .onReceive(viewModel.signInSuccess, perform: { _ in
            activeDestination = .splash
        })
        .onReceive(viewModel.signUpProcess, perform: { _ in
            activeDestination = .signUpNickname
        })
    }

    private func viewForDestination(_ destination: Destination?) -> AnyView {
        let signUpUserModel = viewModel.signUpUserModel
        switch destination {
        case .splash:
            return AnyView(SplashView())
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
