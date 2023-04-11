import SwiftUI

struct SignInView: View {

    @EnvironmentObject var appFlowManager: AppFlowManager
    @EnvironmentObject var viewModel: SignInViewModel
    @State private var activeDestination: Destination?

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    Image("ic_klock")
                        .padding(.top, 130)
                        .padding(.bottom, 32)

                    Text("여기까지 온 당신, 이미 반은 성공!")
                        .foregroundColor(FancyColor.primary.color)
                        .font(.system(size: 16))
                        .padding(.bottom, 4)

                    Text("제대로 성공하러 가볼까요?")
                        .foregroundColor(FancyColor.primary.color)
                        .font(.system(size: 24))
                        .padding(.bottom, 80)

                    FancyButton(title: "페이스북으로 시작하기", action: {
                        viewModel.signInWithFacebookTapped.send()
                    }, backgroundColor: FancyColor.facebook.color, foregroundColor: .white, icon: Image("ic_facebook"))
                    .padding(.bottom, 18)

                    FancyButton(title: "애플로 시작하기", action: {
                        viewModel.signInWithAppleTapped.send()
                    }, backgroundColor: .black, foregroundColor: .white, icon: Image("ic_apple"))
                }
                .padding()
            }
        }
        .background(FancyColor.background.color.edgesIgnoringSafeArea(.all))
        .onAppear {
            viewModel.onSignInWithFacebook = signInSuccessful
            viewModel.onSignUpProcess = signUpProcess
            viewModel.onSignInSuccess = signInSuccessful
        }
        .onReceive(viewModel.signInSuccess, perform: { _ in
            appFlowManager.navigateToDestination.send(.home)
        })
        .onReceive(viewModel.signUpProcess, perform: { _ in
            activeDestination = .signUpUsername
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
        case .signUpUsername:
            return AnyView(SignUpUsernameView(viewModel: Container.shared.resolve(SignUpViewModel.self)).environmentObject(signUpUserModel))
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
        SignInView()
    }
}


