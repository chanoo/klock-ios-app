import SwiftUI

struct SignInView: View {
    @ObservedObject var viewModel: SignInViewModel
    @Environment(\.managedObjectContext) private var viewContext

    @ViewBuilder
    var destinationView: some View {
        if let destination = viewModel.destination {
            switch destination {
            case .home:
                HomeView() // HomeView를 구현하신 것으로 가정합니다.
            case .signUp:
                SignUpView(viewModel: SignUpViewModel()) // 컨테이너를 사용하지 않고 직접 인스턴스를 생성합니다.
            default:
                EmptyView()
            }
        } else {
            EmptyView()
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack {
                        FancyTextField(placeholder: "이메일 주소", text: $viewModel.email, keyboardType: .emailAddress)
                            .padding(.top, 200)

                        FancyTextField(placeholder: "비밀번호", text: $viewModel.password, isSecureField: true)
                            .padding(.bottom, 20)

                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding(.bottom, 20)
                        }

                        FancyButton(title: "로그인", action: {
                            viewModel.signInButtonTapped.send()
                        }, backgroundColor: .blue, foregroundColor: .white)
                        .padding(.bottom, 20)

                        // Divider
                        RoundedRectangle(cornerRadius: 0)
                            .fill(Color.gray)
                            .frame(height: 1)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 30)

                        FancyButton(title: "페이스북으로 시작하기", action: {
                            viewModel.signInWithFacebookTapped.send()
                        }, backgroundColor: Color("FacebookColor"), foregroundColor: .white, icon: Image("ic_facebook"))

                        FancyButton(title: "애플로 시작하기", action: {
                            viewModel.signInWithAppleTapped.send()
                        }, backgroundColor: .black, foregroundColor: .white, icon: Image("ic_apple"))

                    }
                    .padding()
                }
                NavigationLink(
                    destination: destinationView,
                    isActive: .constant(viewModel.destination != nil),
                    label: {
                        EmptyView()
                    }
                )
                .onAppear {
                    viewModel.resetDestination()
                }
            }
        }
    }
}
